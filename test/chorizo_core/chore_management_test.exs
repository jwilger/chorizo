defmodule ChorizoCore.ChoreManagementTest do
  use ExUnit.Case, async: true
  import Mox

  doctest ChorizoCore.ChoreManagement

  alias ChorizoCore.Entities.{User, Chore}

  defp create_chore(chore, as_user) do
    ChorizoCore.ChoreManagement.create_chore(
      chore, as_user,
      chores_repo: ChorizoCore.ChoreManagementTest.MockChores,
      users_repo: ChorizoCore.ChoreManagementTest.MockUsers,
      auth_mod: ChorizoCore.ChoreManagementTest.MockAuth
    )
  end

  setup_all do
    defmock(ChorizoCore.ChoreManagementTest.MockAuth,
            for: ChorizoCore.Authorization)
    defmock(ChorizoCore.ChoreManagementTest.MockUsers,
            for: ChorizoCore.Repositories.API)
    defmock(ChorizoCore.ChoreManagementTest.MockChores,
            for: ChorizoCore.Repositories.API)
    {
      :ok,
      auth_mod: ChorizoCore.ChoreManagementTest.MockAuth,
      users_repo: ChorizoCore.ChoreManagementTest.MockUsers,
      chores_repo: ChorizoCore.ChoreManagementTest.MockChores
    }
  end

  setup :verify_on_exit!

  describe "create_chore/2" do
    test "checks that the user has the :manage_chores permission",
    %{auth_mod: auth_mod, users_repo: users_repo} do
      user = %User{}
      auth_mod
      |> expect(:authorized?, fn :manage_chores, ^user, ^users_repo ->
        false
      end)
      create_chore(Chore.new, user)
    end
  end

  describe "create_chore/2 when the user is authorized" do
    setup context do
      context[:auth_mod]
      |> stub(:authorized?, fn _, _, _ -> true end)
      context[:chores_repo]
      |> stub(:insert, &({:ok, &1}))
      context
    end

    test "inserts the chore into the chores repo",
    %{chores_repo: chores_repo} do
      chore = Chore.new(name: "foo")
      chores_repo
      |> expect(:insert, fn ^chore -> {:ok, chore} end)
      create_chore(chore, %User{})
    end

    test "returns the inserted chore" do
      chore = Chore.new(name: "foo")
      assert {:ok, ^chore} = create_chore(chore, %User{})
    end
  end

  describe "create_chore/2 when the user is not authorized" do
    setup context do
      context[:auth_mod]
      |> stub(:authorized?, fn _, _, _ -> false end)
      context
    end

    test "does not insert the chore" do
      # would get an unexpected function call error if we tried to call insert/1
      # on the mock
      create_chore(Chore.new, %User{})
    end

    test "returns :not_authorized" do
      assert :not_authorized = create_chore(Chore.new, %User{})
    end
  end
end
