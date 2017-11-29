defmodule ChorizoCore.UserManagement do
  @moduledoc """
  External API for managing user accounts
  """

  alias ChorizoCore.{Authorization, Entities.User, Repositories.Users}

  defdelegate authorized?(permission, user, users_repo), to: Authorization

  def create_user(users_repo \\ Users, %User{} = user, as: as) do
    if authorized?(:manage_users, as, users_repo) do
      users_repo.insert(user)
    else
      :not_authorized
    end
  end
end
