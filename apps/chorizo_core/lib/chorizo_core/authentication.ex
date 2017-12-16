defmodule ChorizoCore.Authentication do
  @moduledoc """
  Provides functions for authenticating users
  """

  alias ChorizoCore.Repositories.Users

  defmodule Hasher do
    @moduledoc false

    @callback check_pass(ChorizoCore.Entities.User.t, String.t)
      :: {:ok, ChorizoCore.Entities.User.t} | {:error, String.t}

    @callback hashpwsalt(String.t) :: String.t

    defdelegate check_pass(user, password), to: Comeonin.Argon2
    defdelegate hashpwsalt(password), to: Comeonin.Argon2
  end

  @doc """
  Authenticates a username and password combination, returning the user if a
  match is found.
  """
  @spec authenticate_user(username: String.t, password: String.t)
    :: {:ok, ChorizoCore.Entities.User.t} | {:failed, nil}
  def authenticate_user(username: username, password: password),
    do: authenticate_user(username: username, password: password,
                          users_repo: Users, hasher: Hasher)
  def authenticate_user(username: username, password: password,
                        users_repo: users_repo, hasher: hasher)
  do
    with {:ok, user} <- users_repo.first(username: username),
         {:ok, user} <- hasher.check_pass(user, password)
    do
      {:ok, user}
    else
      _ -> {:failed, nil}
    end
  end
end
