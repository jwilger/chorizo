defmodule ChorizoCore.UsersRepositoryTest do
  use ExUnit.Case, async: true
  alias ChorizoCore.{UsersRepository, User}

  describe "new/0" do
    test "returns an empty list" do
      assert {:ok, []} = UsersRepository.new
    end
  end

  describe "new/1" do
    test "returns a list containing the users it was passed as an argument" do
      user_a = User.new(username: "Fred")
      user_b = User.new(username: "Wilma")
      {:ok, list} = UsersRepository.new([user_a, user_b])
      assert Enum.count(list) == 2
      assert {:ok, %User{}} =
        UsersRepository.find_by_username(user_a.username, list)
      assert {:ok, %User{}} =
        UsersRepository.find_by_username(user_b.username, list)
    end
  end

  describe "insert/1" do
    test "adds valid %User{} to the list" do
      {:ok, users} = UsersRepository.new
      new_user = valid_user("bob")
      {:ok, %User{username: "bob"} = user, users} =
        UsersRepository.insert(new_user, users)
      assert user in users
    end

    test "makes the user an admin if it is the first user added" do
      {:ok, users} = UsersRepository.new
      {:ok, user, _users} = UsersRepository.insert(valid_user("bob"), users)
      assert %{admin: true} = user
    end

    test "does not remove existing users from the list" do
      user_a = User.new(username: "Fred")
      user_b = User.new(username: "Wilma")
      {:ok, users} = UsersRepository.new([user_a, user_b])
      assert {:ok, _user, [_ | ^users]} =
        UsersRepository.insert(valid_user("bob"), users)
    end

    test "does not let you add duplicate usernames" do
      {:ok, users} = UsersRepository.new([valid_user("bob")])
      assert {:error, "username bob is taken"} =
        UsersRepository.insert(valid_user("bob"), users)
    end
  end

  describe "find_by_username/2" do
    test "returns the user with the matching username" do
      bob = valid_user("bob")
      {:ok, users} = UsersRepository.new([bob])
      assert {:ok, %User{username: "bob"}} = UsersRepository.find_by_username("bob", users)
    end

    test "returns :not_found if there is no user with that username" do
      bob = valid_user("bob")
      {:ok, users} = UsersRepository.new([bob])
      assert :not_found = UsersRepository.find_by_username("alice", users)
    end
  end

  defp valid_user(username) do
    User.new(username: username)
  end
end
