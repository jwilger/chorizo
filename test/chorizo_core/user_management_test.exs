defmodule ChorizoCore.UserManagementTest do
  use ExUnit.Case

  doctest ChorizoCore.UserManagement

  alias ChorizoCore.{Entities.User, UserManagement, Repositories.Users}

  defdelegate create_user(server, user, options), to: UserManagement

  describe "create_user/3" do
    test "as anonymous user when no users exist" do
      repo_pid = repo()
      assert {:ok, %User{username: "bob", admin: true}} =
        create_user(repo_pid, %User{username: "bob"}, as: anonymous_user())
    end

    test "as anonynmous user when users already exist" do
      repo_pid = repo()
      create_user(repo_pid, %User{username: "bob"}, as: anonymous_user())
      assert :not_authorized =
        create_user(repo_pid, %User{username: "alice"}, as: anonymous_user())
    end

    test "as a user who does not exist" do
      repo_pid = repo()
      assert :not_authorized =
        create_user(repo_pid, %User{username: "bob"},
                    as: User.new(username: "Fred"))
    end

    test "as a user who is not an admin" do
      repo_pid = repo()
      {:ok, admin} = create_user(repo_pid,
                                 %User{username: "admin", admin: true},
                                 as: anonymous_user())
      {:ok, non_admin} = create_user(repo_pid, %User{username: "nonadmin"},
                                     as: admin)
      assert :not_authorized =
        create_user(repo_pid, %User{username: "bob"}, as: non_admin)
    end

    test "as a user who is a admin" do
      repo_pid = repo()
      {:ok, admin} = create_user(repo_pid,
                                 %User{username: "admin", admin: true},
                                 as: anonymous_user())
      assert {:ok, %User{username: "bob"}} =
        create_user(repo_pid, %User{username: "bob"}, as: admin)
    end
  end

  defp repo do
    {:ok, pid} = Users.start_link([], :local)
    pid
  end

  defp anonymous_user do
    User.anonymous!
  end
end
