defmodule ChorizoCore.Authorization do
  @moduledoc """
  Used to determine whether a particular user has a named permission
  """

  alias ChorizoCore.{User, UsersRepository}

  def authorized?(permission, user,
                  users_repository \\ UsersRepository.server_name)

  def authorized?(:manage_users, %User{anonymous: true}, repo) do
    {:ok, count} = UsersRepository.count(repo)
    count == 0
  end

  def authorized?(:manage_users, %User{} = user, repo) do
    find_and_authorize(repo, user, &(&1.admin))
  end

  defp find_and_authorize(repo, user, authorizer) do
    with {:ok, user} <- UsersRepository.find_by_username(repo, user.username)
    do
      authorizer.(user)
    else
      :not_found -> false
    end
  end
end
