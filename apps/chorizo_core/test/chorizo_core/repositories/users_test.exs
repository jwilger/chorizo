defmodule ChorizoCore.Repositories.UsersTest do
  use ExUnit.Case
  alias ChorizoCore.Repositories.Users
  alias ChorizoCore.Entities.User

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ChorizoCore.Repositories.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(ChorizoCore.Repositories.Repo,
                                   {:shared, self()})
  end

  describe "insert/1" do
    test "username must be unique" do
      Users.insert(User.changeset(%{username: "bob"}))
      {:error, %{errors: errors}} =
        Users.insert(User.changeset(%{username: "bob"}))
      assert {"has already been taken", _} = Keyword.get(errors, :username)
    end
  end

  describe "count/0" do
    test "returns the number of users in the repository" do
      assert 0 = Users.count()
      user = User.changeset(%{username: "bob"})
      {:ok, _} = Users.insert(user)
      assert 1 = Users.count()
      user = User.changeset(%{username: "jan"})
      {:ok, _} = Users.insert(user)
      assert 2 = Users.count()
    end
  end

  describe "first/1" do
    setup do
      {:ok, _} = %{username: "bob", admin: true}
                 |> User.changeset
                 |> Users.insert
      {:ok, _} = %{username: "ann", admin: false}
                 |> User.changeset
                 |> Users.insert
      {:ok, _} = %{username: "tim", admin: false}
                 |> User.changeset
                 |> Users.insert
      []
    end

    test "returns :not_found when no users in the repository match" do
      assert {:not_found, nil} = Users.first(username: "tom")
      assert {:not_found, nil} = Users.first(username: "bob", admin: false)
    end

    test "returns matching user when only one user matches" do
      assert {:ok, %User{username: "bob"}} =
        Users.first(username: "bob")
    end

    test "returns first matching user in insertion order when multiple " <>
      "users match" do
      assert {:ok, %User{username: "ann"}} =
        Users.first(admin: false)
    end
  end
end
