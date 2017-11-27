defmodule ChorizoCore.UserManagement do
  alias ChorizoCore.{User, UsersRepository}

  def create_user(server \\ {:global, UsersRepository}, user, options)

  def create_user(server, %User{} = user, as: %User{anonymous: true}) do
    {:ok, count} = UsersRepository.count(server)
    if count > 0 do
      :not_authorized
    else
      UsersRepository.insert(server, user)
    end
  end

  def create_user(server, %User{} = user, as: as) do
    if authorized?(server, :create_user, as) do
      UsersRepository.insert(server, user)
    else
      :not_authorized
    end
  end

  defp authorized?(server, :create_user, %User{} = user) do
    with {:ok, %User{admin: true}} <-
      UsersRepository.find_by_username(server, user.username)
    do
      true
    else
      :not_found -> false
      {:ok, _user} -> false
    end
  end
end
