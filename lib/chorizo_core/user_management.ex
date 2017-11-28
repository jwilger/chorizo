defmodule ChorizoCore.UserManagement do
  @moduledoc """
  External API for managing user accounts
  """

  alias ChorizoCore.{Authorization, User, UsersRepository}

  defdelegate authorized?(permission, user, server), to: Authorization
  defdelegate users_repo(), to: UsersRepository, as: :server_name

  def create_user(server \\ users_repo(), %User{} = user, as: as) do
    if authorized?(:manage_users, as, server) do
      UsersRepository.insert(server, user)
    else
      :not_authorized
    end
  end
end
