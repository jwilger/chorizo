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
  @spec create_chore(chore :: Chore.t | map, as_user :: User.t)
    :: {:ok, Chore.t} | {:error, Ecto.Changeset.t} | :not_authorized
  def create_chore(chore, user),
    do: create_chore(chore, user, chores_repo: Chores, users_repo: Users,
                     auth_mod: Authorization)

  @doc """
  Creates a new chore in the chore library

  This version allows explicit dependencies to be passed in. Prefer the use of
  `create_chore/2` over `create_chore/4` whenever possible.
  """
  @spec create_chore(chore :: Chore.t | map, as_user :: User.t,
                     [chores_repo: Chores.t,
                      users_repo: Users.t,
                      auth_mod: Authorization.t])
    :: {:ok, Chore.t} | {:error, Ecto.Changeset.t} | :not_authorized
  def create_chore(%Chore{} = chore, as_user, options) do
    chore
    |> Map.from_struct()
    |> create_chore(as_user, options)
  end
  def create_chore(%{} = chore, %User{} = user, chores_repo: chores_repo,
                   users_repo: users_repo, auth_mod: auth_mod) do
    with true <- auth_mod.authorized?(:manage_chores, user, users_repo),
         {:ok, chore} <- %Chore{}
         |> Chore.changeset(chore)
         |> chores_repo.insert
    do
      {:ok, chore}
    else
      false -> :not_authorized
      {:error, changeset} -> {:error, changeset}
    end
  end
end
