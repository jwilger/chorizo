defmodule ChorizoCore.UserManagement do
  use GenServer

  alias ChorizoCore.{User, UsersRepository}

  def start_link do
    GenServer.start_link(__MODULE__, [], name: server_name())
  end

  def server_name do
    {:global, __MODULE__}
  end

  def init(_) do
    UsersRepository.new
  end

  def create_user(server, %User{} = user, as: %User{} = as) do
    GenServer.call(server, {:create_user, user, as: as})
  end

  def handle_call({:create_user, user, [as: as]}, _from, current_state) do
    handle_create_user(user, as, current_state)
  end

  defp handle_create_user(%User{} = user, %User{anonymous: true},
                          current_state) do
    if users_exist?(current_state) do
      not_authorized_reply(current_state)
    else
      create_user_and_reply(user, current_state)
    end
  end
  defp handle_create_user(%User{} = user, %User{} = as, current_state) do
    if authorized?(:create_user, as, current_state) do
      create_user_and_reply(user, current_state)
    else
      not_authorized_reply(current_state)
    end
  end

  defp authorized?(:create_user, %User{anonymous: false} = user, state) do
    with {:ok, %User{admin: true}} <-
      UsersRepository.find_by_username(user.username, state)
    do
      true
    else
      :not_found -> false
      {:ok, _user} -> false
    end
  end

  defp users_exist?(state) do
    UsersRepository.any?(state)
  end

  defp create_user_and_reply(user, current_state) do
    {:ok, user, new_state} = UsersRepository.insert(user, current_state)
    {:reply, {:ok, user}, new_state}
  end

  defp not_authorized_reply(current_state) do
    {:reply, :not_authorized, current_state}
  end
end
