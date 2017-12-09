defmodule ChorizoCore.AuthorizationTest do
  use ExUnit.Case, async: true
  import Mox
  doctest ChorizoCore.Authorization

  alias ChorizoCore.{Entities.User, Authorization}
  alias ChorizoCore.AuthorizationTest.MockUsers

  defdelegate authorized?(permission, user, users_repository), to: Authorization

  setup :verify_on_exit!

  setup_all do
    defmock(ChorizoCore.AuthorizationTest.MockUsers,
                for: ChorizoCore.Repositories.API)
    {:ok, users_repo: MockUsers}
  end

  describe "authorized?/3 when called with an invalid permission" do
    test "it raises an InvalidPermissionError", %{users_repo: users_repo} do
      assert_raise(
        ChorizoCore.Authorization.InvalidPermissionError,
        ~r{:this_is_clearly_going_to_be_invalid},
        fn ->
          authorized?(:this_is_clearly_going_to_be_invalid,
                      User.new, users_repo)
        end
      )
    end
  end

  describe "authorized?/3 for :manage_users" do
    test "is true when the user is anonymous and there are no users in " <>
      "the repository",
    %{users_repo: repo} do
      repo
      |> expect(:count, fn -> {:ok, 0} end)
      assert authorized?(:manage_users, User.anonymous!, repo)
    end

    test "is false when the user is anonymous and there is a user in the " <>
      "repository already",
    %{users_repo: repo} do
      repo
      |> expect(:count, fn -> {:ok, 1} end)
      refute authorized?(:manage_users, User.anonymous!, repo)
    end

    test "is true when the user is an admin",
    %{users_repo: repo} do
      admin = User.new(username: "admin", admin: true)
      repo
      |> expect(:first, fn [username: "admin"] -> {:ok, admin} end)
      assert authorized?(:manage_users, admin, repo)
    end

    test "is false when the user is not an admin",
    %{users_repo: repo} do
      normal = User.new(username: "normal")
      repo
      |> expect(:first, fn [username: "normal"] -> {:ok, normal} end)
      refute authorized?(:manage_users, normal, repo)
    end

    test "is false when the user does not exist",
    %{users_repo: repo} do
      nope = User.new(username: "nope", admin: true)
      repo
      |> expect(:first, fn [username: "nope"] -> {:not_found, nil} end)
      refute authorized?(:manage_users, nope, repo)
    end
  end

  describe "authorized?/3 for :manage_chores" do
    test "is true when the user is an admin",
    %{users_repo: repo} do
      admin = User.new(username: "admin", admin: true)
      repo
      |> expect(:first, fn [username: "admin"] -> {:ok, admin} end)
      assert authorized?(:manage_chores, admin, repo)
    end

    test "is false when the user is not an admin",
    %{users_repo: repo} do
      normal = User.new(username: "normal")
      repo
      |> expect(:first, fn [username: "normal"] -> {:ok, normal} end)
      refute authorized?(:manage_chores, normal, repo)
    end

    test "is false when the user does not exist",
    %{users_repo: repo} do
      nope = User.new(username: "nope", admin: true)
      repo
      |> expect(:first, fn [username: "nope"] -> {:not_found, nil} end)
      refute authorized?(:manage_chores, nope, repo)
    end

    test "is false when the user is anonymous" do
      refute authorized?(:manage_chores, User.anonymous!, MockUsers)
    end
  end
end
