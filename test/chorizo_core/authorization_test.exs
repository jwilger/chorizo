defmodule ChorizoCore.AuthorizationTest do
  use ExUnit.Case, async: true
  doctest ChorizoCore.Authorization

  alias ChorizoCore.{Entities.User, UsersRepository, Authorization}

  defdelegate authorized?(permission, user, users_repository), to: Authorization

  describe "authorized?(:manage_users, %User{anonymous: true})" do
    test "when there are no users in the repository" do
      repo = users_repo()
      assert authorized?(:manage_users, anonymous_user(), repo)
    end

    test "when there is a user in the repository already" do
      repo = users_repo([admin_user()])
      refute authorized?(:manage_users, anonymous_user(), repo)
    end
  end

  describe "authorized?/2" do
    test "a user who is an admin can manage users" do
      repo = users_repo([admin_user(), normal_user()])
      assert authorized?(:manage_users, admin_user(), repo)
    end

    test "a user who is not an admin can not manage users" do
      repo = users_repo([admin_user(), normal_user()])
      refute authorized?(:manage_users, normal_user(), repo)
    end

    test "a user who does not exist can not manage users" do
      repo = users_repo([admin_user(), normal_user()])
      refute authorized?(:manage_users, User.new(username: "nope"), repo)
    end
  end

  defp admin_user do
    User.new(username: "admin", admin: true)
  end

  defp normal_user do
    User.new(username: "normal")
  end

  defp anonymous_user do
    User.anonymous!
  end

  defp users_repo(users \\ []) when is_list(users) do
    {:ok, pid} = UsersRepository.start_link(users, :local)
    pid
  end
end
