defmodule ChorizoCore.ChoreManagement do
  @moduledoc """
  Internal API for managing Chores

  See `ChorizoCore` module for external API.
  """

  alias ChorizoCore.Authorization
  alias ChorizoCore.Repositories.{Users, Chores}
  alias ChorizoCore.Entities.{User, Chore}

  @doc """
  Creates a new chore in the chore library

  Requires the `:manage_chores` permission.
  """
  @spec create_chore(Chore.t, User.t) :: {:ok, Chore.t} | :not_authorized
  def create_chore(chore, user),
    do: create_chore(chore, user, chores_repo: Chores, users_repo: Users,
                     auth_mod: Authorization)

  @doc """
  Creates a new chore in the chore library

  This version allows explicit dependencies to be passed in. Prefer the use of
  `create_chore/2` over `create_chore/4` whenever possible.
  """
  @spec create_chore(Chore.t, User.t,
                     [chores_repo: Chores.t,
                      users_repo: Users.t,
                      auth_mod: Authorization.t])
    :: {:ok, Chore.t} | :not_authorized
  def create_chore(chore, user, chores_repo: chores_repo,
                   users_repo: users_repo, auth_mod: auth_mod) do
    if auth_mod.authorized?(:manage_chores, user, users_repo) do
      chores_repo.insert(chore)
    else
      :not_authorized
    end
  end
end
