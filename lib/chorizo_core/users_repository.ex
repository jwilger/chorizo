defmodule ChorizoCore.UsersRepository do
  alias ChorizoCore.User

  defdelegate any?(enum), to: Enum

  def insert(%User{} = user, [] = _users) do
     user = Map.put(user, :admin, true)
    {:ok, user, [user]}
  end
  def insert(%User{} = user, users) when is_list(users) do
    if Enum.any?(users, &(user.username == &1.username)) do
      {:error, "username " <> user.username <> " is taken"}
    else
      {:ok, user, [user | users]}
    end
  end

  def new, do: {:ok, []}
  def new(users) when is_list(users) do
    users = Enum.reduce(users, [], fn user, acc ->
      {:ok, _user, users} = insert(user, acc)
      users
    end)
    {:ok, users}
  end

  def find_by_username(username, users) do
    Enum.find_value(users, :not_found, fn user ->
      user.username == username && {:ok, user}
    end)
  end
end
