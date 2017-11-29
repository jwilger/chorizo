defmodule ChorizoCore.Repositories.Users do
  use ExUnit.Case, async: true
  alias __MODULE__
  alias ChorizoCore.Entities.User

  describe "insert/1" do
    test "adds valid %User{} to the repository" do
      repo_pid = repo()
      new_user = valid_user("bob")
      {:ok, _user} = Users.insert(repo_pid, new_user)
      assert {:ok, _} = Users.find_by_username(repo_pid, "bob")
    end

    test "makes the user an admin if it is the first user added" do
      repo_pid = repo()
      {:ok, user} = Users.insert(repo_pid, valid_user("bob"))
      assert %{admin: true} = user
    end

    test "does not remove existing users" do
      user_a = User.new(username: "Fred")
      user_b = User.new(username: "Wilma")
      repo_pid = repo([user_a, user_b])
      {:ok, _user} = Users.insert(repo_pid, valid_user("bob"))
      assert {:ok, _} = Users.find_by_username(repo_pid, "Fred")
      assert {:ok, _} = Users.find_by_username(repo_pid, "Wilma")
    end

    test "does not let you add duplicate usernames" do
      repo_pid = repo([valid_user("bob")])
      assert {:error, "attempted to insert duplicate username"} =
        Users.insert(repo_pid, valid_user("bob"))
    end
  end

  describe "find_by_username/2" do
    test "returns the user with the matching username" do
      repo_pid = repo([valid_user("bob")])
      assert {:ok, %User{username: "bob"}} =
        Users.find_by_username(repo_pid, "bob")
    end

    test "returns :not_found if there is no user with that username" do
      repo_pid = repo([valid_user("bob")])
      assert :not_found = Users.find_by_username(repo_pid, "alice")
    end
  end

  describe "count/2" do
    test "returns the number of users in the repository" do
      repo_pid = repo()
      assert {:ok, 0} = Users.count(repo_pid)
      repo_pid = repo([valid_user("bob")])
      assert {:ok, 1} = Users.count(repo_pid)
    end
  end

  defp repo(users \\ []) do
    {:ok, pid} = Users.start_link(users, :local)
    pid
  end

  defp valid_user(username) do
    User.new(username: username)
  end
end
