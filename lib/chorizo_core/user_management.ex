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
  @spec create_user(user :: User.t | map, as_user :: User.t)
    :: {:ok, User.t} | {:error, Ecto.Changeset.t} | :not_authorized
  def create_user(user, as_user),
    do: create_user(user, as_user, users_repo: Users, auth_mod: Authorization)

  @doc """
  Create a new user who will be able to access Chorizo

  This version allows explicit dependencies to be passed in. Prefer the use of
  `create_user/2` over `create_user/4` whenever possible.
  """
  @spec create_user(user :: User.t | map, as_user :: User.t,
                    [users_repo: Users.t, auth_mod: Authorization.t])
    :: {:ok, User.t} | {:error, Ecto.Changeset.t} | :not_authorized
  def create_user(%User{} = user, as_user, options) do
    user
    |> Map.from_struct()
    |> create_user(as_user, options)
  end
  def create_user(%{} = user, %User{} = as_user,
                  users_repo: users_repo, auth_mod: auth_mod)
  do
    with true <- auth_mod.authorized?(:manage_users, as_user, users_repo),
         {:ok, user} <- %User{}
         |> User.changeset(user)
         |> maybe_make_first_admin(users_repo)
         |> users_repo.insert
    do
      {:ok, user}
    else
      false -> :not_authorized
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp maybe_make_first_admin(user, users_repo) do
    if users_repo.count == 0 do
      Ecto.Changeset.change(user, %{admin: true})
    else
      user
    end
  end
end
