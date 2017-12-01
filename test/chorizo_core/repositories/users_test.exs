defmodule ChorizoCore.Repositories.UsersTest do
  use ExUnit.Case
  alias ChorizoCore.Repositories.Users
  alias ChorizoCore.Entities.User

  setup do
    Users.reset()
    on_exit &Users.reset/0
  end

  describe "insert/1" do
    test "adds valid %User{} to the repository" do
      {:ok, user} = Users.insert(User.new(username: "bob"))
      assert %User{username: "bob"} = user
      assert {:ok, ^user} = Users.first(username: "bob")
    end

    test "makes the user an admin if it is the first user added" do
      {:ok, user} = Users.insert(User.new(username: "bob"))
      assert %{admin: true} = user
    end

    test "does not remove existing users" do
      {:ok, fred} = Users.insert(User.new(username: "Fred"))
      {:ok, wilma} = Users.insert(User.new(username: "Wilma"))
      assert {:ok, ^fred} = Users.first(username: "Fred")
      assert {:ok, ^wilma} = Users.first(username: "Wilma")
    end

    test "does not let you add duplicate usernames" do
      {:ok, user} = Users.insert(User.new(username: "bob"))
      assert {:error, "attempted to insert duplicate username"} =
        Users.insert(User.new(username: "bob"))
    end
  end

  describe "first/1" do
    test "returns the user with the matching attribute" do
      {:ok, user} = Users.insert(User.new(username: "bob"))
      assert {:ok, ^user} = Users.first(username: "bob")
    end

    test "returns :not_found if there is no matching user" do
      assert {:not_found, nil} = Users.first(username: "bob")
    end

    test "returns :not_found if only some attributes match" do
      {:ok, user} = Users.insert(User.new(username: "bob", admin: true))
      assert {:not_found, nil} =
        Users.first(username: "bob", admin: "false")
    end
  end

  describe "count/2" do
    test "returns the number of users in the repository" do
      assert {:ok, 0} = Users.count()
      Users.insert(User.new(username: "bob"))
      assert {:ok, 1} = Users.count()
    end
  end
end
