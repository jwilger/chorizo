defmodule ChorizoCore.UserManagementTest do
  use ExUnit.Case, async: true

  import Mox

  doctest ChorizoCore.UserManagement

  alias ChorizoCore.{Entities.User, UserManagement}
  alias ChorizoCore.UserManagementTest.{MockRepo, MockAuth}

  setup_all do
    defmock(ChorizoCore.UserManagementTest.MockAuth,
            for: ChorizoCore.Authorization)
    defmock(ChorizoCore.UserManagementTest.MockRepo,
            for: ChorizoCore.Repositories.Repo)
    {:ok, auth_mod: MockAuth, users_repo: MockRepo}
  end

  setup :verify_on_exit!

  defp create_user(user, as_user) do
    UserManagement.create_user(
      user, as_user,
      users_repo: ChorizoCore.UserManagementTest.MockRepo,
      auth_mod: ChorizoCore.UserManagementTest.MockAuth
    )
  end

  defp stub_user_insert(_) do
    stub(MockRepo, :insert, fn u ->
      u = Ecto.Changeset.apply_changes(u)
      {:ok, u}
    end)
    :ok
  end

  defp stub_user_count(_) do
    MockRepo
    |> stub(:count, fn -> 1 end)
    :ok
  end

  describe "create_user/3" do
    setup :stub_user_insert
    setup :stub_user_count

    test "checks if the as_user is authorized to :manage_users" do
      as_user = %User{}

      MockAuth
      |> expect(:authorized?, fn :manage_users, ^as_user, MockRepo ->
        true
      end)

      create_user(%{}, as_user)
    end
  end

  describe "create_user/3 when user is authorized" do
    setup :stub_user_insert
    setup :stub_user_count

    setup do
      MockAuth
      |> stub(:authorized?, fn _, _, _ -> true end)
      :ok
    end

    test "new user is inserted into the repository" do
      user = %{username: "bob"}
      MockRepo
      |> expect(:insert, fn %{changes: %{username: "bob"} = u} -> {:ok, u} end)

      create_user(user, %User{})
    end

    test "new user can also be passed as a User struct" do
      assert {:ok, _} = create_user(%User{username: "bob"}, %User{})
    end

    test "new user is returned" do
      user = %{username: "bob"}
      {:ok, %{username: "bob"}} = create_user(user, %User{})
    end

    test "the first user created is always made an admin" do
      MockRepo
      |> stub(:count, fn -> 0 end)
      |> expect(:insert, fn %{changes: %{admin: true} = u} -> {:ok, u} end)

      user = %{username: "bob", admin: false}
      create_user(user, %User{})
    end

    test "subsequent users are not always made an admin" do
      MockRepo
      |> stub(:count, fn -> 1 end)
      |> expect(:insert, fn %{changes: u} ->
        refute Map.has_key?(u, :admin)
        {:ok, u}
      end)

      user = %{username: "bob"}
      create_user(user, %User{})
    end

    test "subsequent users *may* also be made an admin" do
      MockRepo
      |> stub(:count, fn -> 1 end)
      |> expect(:insert, fn %{changes: %{admin: true} = u} -> {:ok, u} end)

      user = %{username: "bob", admin: true}
      create_user(user, %User{})
    end
  end

  describe "create_user/3 when user is not authorized" do
    setup do
      MockAuth
      |> stub(:authorized?, fn _, _, _ -> false end)
      :ok
    end

    test "new user is not inserted into the repository" do
      # if it were, we would get a failure here about no expectation for
      # insert/1
      create_user(%User{}, %User{})
    end

    test ":not_authorized is returned" do
      assert :not_authorized = create_user(%User{}, %User{})
    end
  end
end
