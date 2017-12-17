defmodule ChorizoCore.Repositories.ChoresTest do
  use ExUnit.Case
  alias ChorizoCore.Repositories.Chores
  alias ChorizoCore.Entities.Chore

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ChorizoCore.Repositories.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(ChorizoCore.Repositories.Repo,
                                   {:shared, self()})
  end

  describe "insert/1" do
    test "adds valid %Chore{} to the repository" do
      {:ok, chore} = Chores.insert(Chore.changeset(%{name: "wash dishes"}))
      assert %Chore{name: "wash dishes"} = chore
      assert {:ok, ^chore} = Chores.first(name: "wash dishes")
    end

    test "does not remove existing chores" do
      {:ok, fred} = Chores.insert(Chore.changeset(%{name: "clean room"}))
      {:ok, wilma} = Chores.insert(Chore.changeset(%{name: "sweep floors"}))
      assert {:ok, ^fred} = Chores.first(name: "clean room")
      assert {:ok, ^wilma} = Chores.first(name: "sweep floors")
    end

    test "does not let you add duplicate name" do
      Chores.insert(Chore.changeset(%{name: "wash dishes"}))
      {:error, %{errors: errors}} =
        Chores.insert(Chore.changeset(%{name: "wash dishes"}))
      assert {"has already been taken", _} = Keyword.get(errors, :name)
    end
  end

  describe "first/1" do
    test "returns the chore with the matching attribute" do
      {:ok, chore} = Chores.insert(Chore.changeset(%{name: "wash dishes"}))
      assert {:ok, ^chore} = Chores.first(name: "wash dishes")
    end

    test "returns :not_found if there is no matching chore" do
      assert {:not_found, nil} = Chores.first(name: "wash dishes")
    end

    @tag :pending # Implement once there are more chore attributes
    test "returns :not_found if only some attributes match"
  end

  describe "count/2" do
    test "returns the number of chores in the repository" do
      assert 0 = Chores.count()
      Chores.insert(Chore.changeset(%{name: "wash dishes"}))
      assert 1 = Chores.count()
    end
  end
end
