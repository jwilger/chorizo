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
                for: ChorizoCore.Repositories.Repo)
    {:ok, users_repo: MockUsers}
  end

  describe "authorized?/3 when called with an invalid permission" do
    test "it raises an InvalidPermissionError" do
      assert_raise(
        ChorizoCore.Authorization.InvalidPermissionError,
        ~r{:this_is_clearly_going_to_be_invalid},
        fn ->
          authorized?(:this_is_clearly_going_to_be_invalid,
                      %User{}, MockUsers)
        end
      )
    end
  end

  describe "authorized?/3 for :manage_users" do
    test "is true when the user is anonymous and there are no users in " <>
      "the repository" do
      MockUsers
      |> expect(:count, fn -> 0 end)
      assert authorized?(:manage_users, User.anonymous!, MockUsers)
    end

    test "is false when the user is anonymous and there is a user in the " <>
      "repository already" do
      MockUsers
      |> expect(:count, fn -> 1 end)
      refute authorized?(:manage_users, User.anonymous!, MockUsers)
    end

    test "is true when the user is an admin" do
      admin = %User{username: "admin", admin: true}
      MockUsers
      |> expect(:first, fn [username: "admin"] -> {:ok, admin} end)
      assert authorized?(:manage_users, admin, MockUsers)
    end

    test "is false when the user is not an admin" do
      normal = %User{username: "normal"}
      MockUsers
      |> expect(:first, fn [username: "normal"] -> {:ok, normal} end)
      refute authorized?(:manage_users, normal, MockUsers)
    end

    test "is false when the user does not exist" do
      nope = %User{username: "nope", admin: true}
      MockUsers
      |> expect(:first, fn [username: "nope"] -> {:not_found, nil} end)
      refute authorized?(:manage_users, nope, MockUsers)
    end
  end

  describe "authorized?/3 for :manage_chores" do
    test "is true when the user is an admin" do
      admin = %User{username: "admin", admin: true}
      MockUsers
      |> expect(:first, fn [username: "admin"] -> {:ok, admin} end)
      assert authorized?(:manage_chores, admin, MockUsers)
    end

    test "is false when the user is not an admin" do
      normal = %User{username: "normal"}
      MockUsers
      |> expect(:first, fn [username: "normal"] -> {:ok, normal} end)
      refute authorized?(:manage_chores, normal, MockUsers)
    end

    test "is false when the user does not exist" do
      nope = %User{username: "nope", admin: true}
      MockUsers
      |> expect(:first, fn [username: "nope"] -> {:not_found, nil} end)
      refute authorized?(:manage_chores, nope, MockUsers)
    end

    test "is false when the user is anonymous" do
      refute authorized?(:manage_chores, User.anonymous!, MockUsers)
    end
  end
end
