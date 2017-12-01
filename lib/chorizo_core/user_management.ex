defmodule ChorizoCore.UserManagement do
  @moduledoc """
  External API for managing user accounts
  """

  alias ChorizoCore.{Authorization, Entities.User, Repositories.Users}

  import Authorization, only: [authorized?: 3]

  @doc """
  Create a new user who will be able to access Chorizo

  Requires the `:manage_users` permission
  """
  @spec create_user(Users.t, User.t, as: User.t) :: {:ok, User.t} | :not_authorized
  def create_user(users_repo \\ Users, %User{} = user, as: as) do
    if authorized?(:manage_users, as, users_repo) do
      users_repo.insert(user)
    else
      :not_authorized
    end
  end
end
