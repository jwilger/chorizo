defmodule ChorizoCore.Authorization do
  @moduledoc """
  This module contains many implementations of `authorized/3`, which are used to
  determine if a given user has a given permission.
  """

  defmodule InvalidPermissionError do
    @moduledoc false

    defexception [:message]

    def exception(value) do
      msg = "Authorization library does not contain the requested " <>
        "permission: #{inspect(value)}"
      %InvalidPermissionError{message: msg}
    end
  end

  @typedoc """
  The module implementing the authorization logic. Must implement the
  `ChorizoCore.Repositories.Authorization` behaviour. Defaults to
  `ChorizoCore.Repositories.Authorization`.
  """
  @type t :: module

  @typedoc """
  A named permission used throughout the system
  """
  @type permission :: atom

  alias ChorizoCore.{Entities.User, Repositories.Users}

  @callback authorized?(permission, User.t, Users.t) :: boolean

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
  def authorized?(_, %User{anonymous: true}, _), do: false

  def authorized?(:manage_users, %User{} = user, users_repo) do
    find_and_authorize(users_repo, user, &(&1.admin))
  end

  def authorized?(:manage_chores, %User{} = user, users_repo) do
    find_and_authorize(users_repo, user, &(&1.admin))
  end

  def authorized?(permission, _user, _users_repo) do
    raise InvalidPermissionError, permission
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
