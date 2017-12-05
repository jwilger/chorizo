defmodule ChorizoCore.Authentication do
  alias ChorizoCore.Repositories.Users

  defmodule Hasher do
    @callback check_pass(ChorizoCore.Entities.User.t, String.t)
      :: {:ok, ChorizoCore.Entities.User.t} | {:error, String.t}

    @callback hashpwsalt(String.t) :: String.t

    defdelegate check_pass(user, password), to: Comeonin.Argon2
    defdelegate hashpwsalt(password), to: Comeonin.Argon2
  end

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
