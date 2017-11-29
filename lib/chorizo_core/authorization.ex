defmodule ChorizoCore.Authorization do
  @moduledoc """
  Used to determine whether a particular user has a named permission
  """

  alias ChorizoCore.{Entities.User, Repositories.Users}

  def authorized?(permission, user, users_repo \\ Users)

  def authorized?(:manage_users, %User{anonymous: true}, users_repo) do
    {:ok, count} = users_repo.count
    count == 0
  end

  def authorized?(:manage_users, %User{} = user, users_repo) do
    find_and_authorize(users_repo, user, &(&1.admin))
  end

  defp find_and_authorize(users_repo, user, authorizer) do
    with {:ok, user} <- users_repo.first(username: user.username)
    do
      authorizer.(user)
    else
      {:not_found, _} -> false
    end
  end
end
