defmodule ChorizoCore.Repositories.Users do
  @moduledoc """
  Functions for managing the repository of known user accounts

  Note that, at this time, users are simply stored in a List structure in the
  GenServer state, i.e. all user accounts will disappear if and when the process
  is stopped. Persisting users indefinitely will be addressed in the future.
  """

  alias ChorizoCore.Entities.User
  alias ChorizoCore.Repositories.API
  alias __MODULE__.Server

  @behaviour API

  @typedoc """
  The module implementing the users repository. Must implement the
  `ChorizoCore.Repositories.API` behaviour. Defaults to
  `ChorizoCore.Repositories.Users`.
  """
  @type t :: module

  @doc """
  Resets the repository to be empty

  **IMPORTANT**: This should only ever be called from tests. It is intended to
  reset global repository data in between tests, so that a test is guaranteed a
  clean starting point.
  """
  @spec reset() :: []
  def reset do
    GenServer.call(Server.server_name(), :reset)
  end

  @impl API
  @doc """
  Adds the `user` to the repository
  """
  @spec insert(User.t) :: API.single_result(User.t)
  def insert(%User{} = user) do
    GenServer.call(Server.server_name(), {:insert, user})
  end

  @impl API
  @doc """
  Returns the first user with attributes matching `search_options`

  `search_options` should be a keyword list of `%ChorizoCore.Entities.User{}`
  keys along with a value to be matched. At this time, only exactly-equal values
  are supported.
  """
  @spec first(keyword()) :: API.single_result(User.t)
  def first(search_options \\ []) when is_list(search_options) do
    GenServer.call(Server.server_name(), {:first, search_options})
  end

  @impl API
  @doc """
  Returns the number of users in the repository

  *Note that--at this time--search options are not used, and only the total
  number of users will be returned.*
  """
  @spec count(keyword()) :: API.single_result(integer())
  def count(_search_options \\ []) do
    GenServer.call(Server.server_name(), {:count})
  end

  defmodule Server do
    @moduledoc false

    use GenServer

    alias ChorizoCore.Entities.User

    def server_name do
      {:global, __MODULE__}
    end

    def start_link([]) do
      GenServer.start_link(__MODULE__, [], name: {:global, __MODULE__})
    end

    def start_link(users, :local) do
      GenServer.start_link(__MODULE__, users)
    end

    def init(users) when is_list(users) do
      {:ok, users}
    end

    def handle_call(:reset, _from, _current_state) do
      {:reply, nil, []}
    end

    def handle_call({:insert, %User{} = user}, _from, current_state) do
      user = if Enum.empty?(current_state) do
        Map.put(user, :admin, true)
      else
        user
      end
      if Enum.any?(current_state, &(&1.username == user.username)) do
        {:reply, {:error, "attempted to insert duplicate username"},
          current_state}
      else
        {:reply, {:ok, user}, [user | current_state]}
      end
    end

    def handle_call({:first, search_options}, _from, current_state) do
      result = Enum.find_value(current_state, {:not_found, nil}, fn user ->
        match?(^search_options, user) && {:ok, user}
      end)
      {:reply, result, current_state}
    end

    def handle_call({:count}, _from, current_state) do
      {:reply, {:ok, Enum.count(current_state)}, current_state}
    end
  end
end
