defmodule ChorizoCore.UserManagement do
  @moduledoc """
  External API for managing user accounts
  """

  alias ChorizoCore.{Authorization, Entities.User, Repositories.Users}

  @doc """
  Create a new user who will be able to access Chorizo

  Requires the `:manage_users` permission
  """
  @spec create_user(User.t, [as: User.t], Users.t, Authorization.t) :: {:ok, User.t}
    | :not_authorized
  def create_user(%User{} = user, [as: as], users_repo \\ Users, auth_mod \\ Authorization) do
    if auth_mod.authorized?(:manage_users, as, users_repo) do
      users_repo.insert(user)
    else
      :not_authorized
    end
  end
end
