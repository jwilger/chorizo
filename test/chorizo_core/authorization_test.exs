defmodule ChorizoCore.AuthorizationTest do
  use ExUnit.Case, async: true
  import Mox
  doctest ChorizoCore.Authorization

  alias ChorizoCore.{Entities.User, Authorization}

  defdelegate authorized?(permission, user, users_repository), to: Authorization

  setup :verify_on_exit!

  setup_all do
    defmock(ChorizoCore.Repositories.Users.Mock,
                for: ChorizoCore.Repositories.API)
    {:ok, users_repo: ChorizoCore.Repositories.Users.Mock}
  end

  describe "authorized?(:manage_users, %User{anonymous: true})" do
    test "when there are no users in the repository", %{users_repo: repo} do
      repo
      |> expect(:count, fn -> {:ok, 0} end)
      assert authorized?(:manage_users, User.anonymous!, repo)
    end

    test "when there is a user in the repository already",
    %{users_repo: repo} do
      repo
      |> expect(:count, fn -> {:ok, 1} end)
      refute authorized?(:manage_users, User.anonymous!, repo)
    end
  end

  describe "authorized?/2" do
    test "a user who is an admin can manage users",
    %{users_repo: repo} do
      admin = User.new(username: "admin", admin: true)
      repo
      |> expect(:first, fn [username: "admin"] -> {:ok, admin} end)
      assert authorized?(:manage_users, admin, repo)
    end

    test "a user who is not an admin can not manage users",
    %{users_repo: repo} do
      normal = User.new(username: "normal")
      repo
      |> expect(:first, fn [username: "normal"] -> {:ok, normal} end)
      refute authorized?(:manage_users, normal, repo)
    end

    test "a user who does not exist can not manage users",
    %{users_repo: repo} do
      nope = User.new(username: "nope", admin: true)
      repo
      |> expect(:first, fn [username: "nope"] -> {:not_found, nil} end)
      refute authorized?(:manage_users, nope, repo)
    end
  end
end
