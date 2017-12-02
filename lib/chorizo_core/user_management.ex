defmodule ChorizoCore.UserManagement do
  @moduledoc """
  Internal API for managing user accounts

  See `ChorizoCore` module for external API.
  """

  alias ChorizoCore.{Authorization, Entities.User, Repositories.Users}

  @doc """
  Create a new user who will be able to access Chorizo

  Requires the `:manage_users` permission
  """
  @spec create_user(User.t, User.t) :: {:ok, User.t} | :not_authorized
  def create_user(%User{} = user, %User{} = as_user),
    do: create_user(user, as_user, users_repo: Users, auth_mod: Authorization)

  @doc """
  Create a new user who will be able to access Chorizo

  This version allows explicit dependencies to be passed in. Prefer the use of
  `create_user/2` over `create_user/4` whenever possible.
  """
  @spec create_user(User.t, User.t,
                    [users_repo: Users.t, auth_mod: Authorization.t])
    :: {:ok, User.t} | :not_authorized
  def create_user(%User{} = user, %User{} = as_user,
                  users_repo: users_repo, auth_mod: auth_mod) do
    if auth_mod.authorized?(:manage_users, as_user, users_repo) do
      users_repo.insert(user)
    else
      :not_authorized
    end
  end
end
