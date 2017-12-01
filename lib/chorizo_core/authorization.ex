defmodule ChorizoCore.Authorization do
  @moduledoc """
  Used to determine whether a particular user has a named permission
  """

  @typedoc """
  A named permission used throughout the system
  """
  @type permission :: atom

  alias ChorizoCore.{Entities.User, Repositories.Users}

  @doc """
  Returns true if the user is granted the specified permission

  ## Allowing the first user to be created ##

  When there are no users in the `users_repo`, the anonymous user is granted
  `:manage_users`. This is to allow the first user to be created.
  """
  @spec authorized?(permission, User.t, Users.t) :: boolean
  def authorized?(permission, user, users_repo \\ Users)
  def authorized?(:manage_users, %User{anonymous: true}, users_repo) do
    {:ok, count} = users_repo.count()
    count == 0
  end
  def authorized?(:manage_users, %User{} = user, users_repo) do
    find_and_authorize(users_repo, user, &(&1.admin))
  end

  @spec find_and_authorize(Users.t, User.t, ((User.t) -> boolean)) :: boolean
  defp find_and_authorize(users_repo, user, authorizer) do
    with {:ok, user} <- users_repo.first(username: user.username)
    do
      authorizer.(user)
    else
      {:not_found, _} -> false
    end
  end
end
