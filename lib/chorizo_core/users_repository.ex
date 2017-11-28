defmodule ChorizoCore.UsersRepository do
  @moduledoc """
  Functions for managing the repository of known user accounts

  This module contains the API functions to be used directly by other modules;
  the actual GenServer and callbacks are implemented in the nested
  ChorizoCore.UsersRepository.Server module.

  Note that, at this time, users are simply stored in a List structure in the
  GenServer state, i.e. all user accounts will disappear if and when the process
  is stopped. Persisting users indefinitely will be addressed in the future.
  """

  alias ChorizoCore.User
  alias __MODULE__.Server

  defdelegate start_link(args), to: Server
  defdelegate start_link(args, type), to: Server

  def server_name do
    {:global, __MODULE__.Server}
  end

  def insert(server \\ server_name(), %User{} = user) do
    GenServer.call(server, {:insert, user})
  end

  def find_by_username(server \\ server_name(), username)
  when is_binary(username) do
    GenServer.call(server, {:find_by_username, username})
  end

  def count(server \\ server_name()) do
    GenServer.call(server, {:count})
  end

  defmodule Server do
    @moduledoc """
    Implements the GenServer that holds the known user accounts in its state.
    See ChorizoCore.UsersRepository for the API that is intended to be used by
    other modules for manipulating this state.
    """

    use GenServer

    alias ChorizoCore.User

    def start_link([]) do
      GenServer.start_link(__MODULE__, [], name: {:global, __MODULE__})
    end

    def start_link(users, :local) do
      GenServer.start_link(__MODULE__, users)
    end

    def init(users) when is_list(users) do
      {:ok, users}
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

    def handle_call({:find_by_username, username}, _from, current_state)
    when is_binary(username) do
      result = Enum.find_value(current_state, :not_found, fn user ->
        user.username == username && {:ok, user}
      end)
      {:reply, result, current_state}
    end

    def handle_call({:count}, _from, current_state) do
      {:reply, {:ok, Enum.count(current_state)}, current_state}
    end
  end
end
