defmodule ChorizoCore.UserManagementTest do
  use ExUnit.Case
  doctest ChorizoCore.UserManagement

  alias ChorizoCore.{Entities.User, UserManagement, Repositories.Users}

  defdelegate create_user(user, options), to: UserManagement

  setup do
    Users.reset
    on_exit &Users.reset/0
    {:ok, no: :context}
  end

  describe "create_user/2" do
    test "as anonymous user when no users exist" do
      assert {:ok, %User{username: "bob", admin: true}} =
        create_user(%User{username: "bob"}, as: User.anonymous!)
    end

    test "as anonynmous user when users already exist" do
      create_user(%User{username: "bob"}, as: User.anonymous!)
      assert :not_authorized =
        create_user(%User{username: "alice"}, as: User.anonymous!)
    end

    test "as a user who does not exist" do
      assert :not_authorized =
        create_user(User.new(username: "bob"), as: User.new(username: "Fred"))
    end

    test "as a user who is not an admin" do
      {:ok, admin} = create_user(User.new(username: "admin", admin: true),
                                 as: User.anonymous!)
      {:ok, non_admin} = create_user(User.new(username: "nonadmin"),
                                     as: admin)
      assert :not_authorized =
        create_user(User.new(username: "bob"), as: non_admin)
    end

    test "as a user who is a admin" do
      {:ok, admin} = create_user(User.new(username: "admin", admin: true),
                                 as: User.anonymous!)
      assert {:ok, %User{username: "bob", admin: false}} =
        create_user(User.new(username: "bob"), as: admin)
    end
  end
end
