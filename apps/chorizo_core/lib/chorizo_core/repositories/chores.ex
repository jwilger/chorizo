defmodule ChorizoCore.Repositories.Chores do
  @moduledoc """
  Functions for managing the repository of known chores

  Note that, at this time, chores are simply stored in a List structure in the
  GenServer state, i.e. all chores will disappear if and when the process is
  stopped. Persisting chores indefinitely will be addressed in the future.
  """

  alias ChorizoCore.Entities.Chore
  alias ChorizoCore.Repositories.API
  alias __MODULE__.Server

  @behaviour API

  @typedoc """
  The module implementing the chores repository. Must implement the
  `ChorizoCore.Repositories.API` behaviour. Defaults to
  `ChorizoCore.Repositories.Chores`.
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
  Adds the `chore` to the repository
  """
  @spec insert(Chore.t) :: API.single_result(Chore.t)
  def insert(%Chore{} = chore) do
    GenServer.call(Server.server_name(), {:insert, chore})
  end

  @impl API
  @doc """
  Returns the first chore with attributes matching `search_options`

  `search_options` should be a keyword list of `%ChorizoCore.Entities.Chore{}`
  keys along with a value to be matched. At this time, only exactly-equal values
  are supported.
  """
  @spec first(keyword()) :: API.single_result(Chore.t)
  def first(search_options \\ []) when is_list(search_options) do
    GenServer.call(Server.server_name(), {:first, search_options})
  end

  @impl API
  @doc """
  Returns the number of chores in the repository

  *Note that--at this time--search options are not used, and only the total
  number of chores will be returned.*
  """
  @spec count(keyword()) :: API.single_result(integer())
  def count(_search_options \\ []) do
    GenServer.call(Server.server_name(), {:count})
  end

  defmodule Server do
    @moduledoc false

    use GenServer

    alias ChorizoCore.Entities.Chore

    def server_name do
      {:global, __MODULE__}
    end

    def start_link([]) do
      GenServer.start_link(__MODULE__, [], name: {:global, __MODULE__})
    end

    def start_link(chores, :local) do
      GenServer.start_link(__MODULE__, chores)
    end

    def init(chores) when is_list(chores) do
      {:ok, chores}
    end

    def handle_call(:reset, _from, _current_state) do
      {:reply, nil, []}
    end

    def handle_call({:insert, %Chore{} = chore}, _from, current_state) do
      if Enum.any?(current_state, &(&1.name == chore.name)) do
        {:reply, {:error, "attempted to insert duplicate name"},
          current_state}
      else
        {:reply, {:ok, chore}, [chore | current_state]}
      end
    end

    def handle_call({:first, search_options}, _from, current_state) do
      result = Enum.find_value(current_state, {:not_found, nil}, fn chore ->
        matcher = fn {key, value} -> match?(%{^key => ^value}, chore) end
        Enum.all?(search_options, matcher) && {:ok, chore}
      end)
      {:reply, result, current_state}
    end

    def handle_call({:count}, _from, current_state) do
      {:reply, {:ok, Enum.count(current_state)}, current_state}
    end
  end
end
