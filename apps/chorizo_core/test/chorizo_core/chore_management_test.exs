defmodule ChorizoCore.ChoreManagementTest do
  use ExUnit.Case, async: true
  import Mox

  doctest ChorizoCore.ChoreManagement

  alias ChorizoCore.Entities.{User, Chore}
  alias ChorizoCore.ChoreManagementTest.{MockChores, MockUsers, MockAuth}

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
            for: ChorizoCore.Repositories.Repo)
    defmock(ChorizoCore.ChoreManagementTest.MockChores,
            for: ChorizoCore.Repositories.Repo)
    {
      :ok,
      auth_mod: MockAuth, users_repo: MockUsers, chores_repo: MockChores
    }
  end

  defp stub_chore_insert(_) do
    stub(MockChores, :insert, fn c ->
      c = Ecto.Changeset.apply_changes(c)
      {:ok, c}
    end)
    :ok
  end

  setup :verify_on_exit!

  describe "create_chore/3" do
    test "checks that the user has the :manage_chores permission" do
      as_user = %User{}
      MockAuth
      |> expect(:authorized?, fn :manage_chores, ^as_user, MockUsers ->
        false
      end)
      create_chore(%{}, as_user)
    end
  end

  describe "create_chore/3 when the user is authorized" do
    setup :stub_chore_insert

    setup context do
      context[:auth_mod]
      |> stub(:authorized?, fn _, _, _ -> true end)
      :ok
    end

    test "inserts the chore into the chores repo" do
      chore = %{name: "foo"}
      MockChores
      |> expect(:insert, fn %{changes: %{name: "foo"} = c} -> {:ok, c} end)
      create_chore(chore, %User{})
    end

    test "returns the inserted chore" do
      chore = %{name: "foo"}
      assert {:ok, %Chore{name: "foo"}} = create_chore(chore, %User{})
    end
  end

  describe "create_chore/3 when the user is not authorized" do
    setup context do
      context[:auth_mod]
      |> stub(:authorized?, fn _, _, _ -> false end)
      context
    end

    test "does not insert the chore" do
      # would get an unexpected function call error if we tried to call insert/1
      # on the mock
      create_chore(%{}, %User{})
    end

    test "returns :not_authorized" do
      assert :not_authorized = create_chore(%{}, %User{})
    end
  end
end
