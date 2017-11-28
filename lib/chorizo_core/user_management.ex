defmodule ChorizoCore.UserManagement do
  @moduledoc """
  External API for managing user accounts
  """

  alias ChorizoCore.{Authorization, User, UsersRepository}

  defdelegate authorized?(permission, user, server), to: Authorization

  def create_user(server \\ UsersRepository.server_name(), user, options)

  def create_user(server, %User{} = user, as: as) do
    if authorized?(:manage_users, as, server) do
      UsersRepository.insert(server, user)
    else
      :not_authorized
    end
  end
end
