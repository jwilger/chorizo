defmodule ChorizoCore.UserManagementTest do
  use ExUnit.Case, async: true

  doctest ChorizoCore.UserManagement

  alias ChorizoCore.{User, UserManagement}

  setup do
    {:ok, pid} = UserManagement.start_link
    {:ok, user_management_pid: pid}
  end

  describe "create_user/3" do
    test "as anonymous user when no users exist", context do
      assert {:ok, %User{username: "bob", admin: true}} =
        create_user(context, %{username: "bob"}, as: anonymous_user())
    end

    test "as anonynmous user when users already exist", context do
      create_user(context, %{username: "bob"}, as: anonymous_user())
      assert :not_authorized =
        create_user(context, %{username: "alice"}, as: anonymous_user())
    end

    test "as a user who does not exist", context do
      assert :not_authorized =
        create_user(context, %{username: "bob"}, as: User.new(username: "Fred"))
    end

    test "as a user who is not an admin", context do
      {:ok, admin} = create_user(context, %{username: "admin", admin: true},
                                 as: anonymous_user())
      {:ok, non_admin} = create_user(context, %{username: "nonadmin"},
                                     as: admin)
      assert :not_authorized =
        create_user(context, %{username: "bob"}, as: non_admin)
    end

    test "as a user who is a admin", context do
      {:ok, admin} = create_user(context, %{username: "admin", admin: true},
                                 as: anonymous_user())
      assert {:ok, %User{username: "bob"}} =
        create_user(context, %{username: "bob"}, as: admin)
    end
  end

  defp anonymous_user do
    User.anonymous!
  end

  defp create_user(context, properties, as: as) do
    UserManagement.create_user(context[:user_management_pid],
                               User.new(properties),
                               as: as)
  end
end
