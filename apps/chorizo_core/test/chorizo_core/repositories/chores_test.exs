defmodule ChorizoCore.Repositories.ChoresTest do
  use ExUnit.Case
  alias ChorizoCore.Repositories.Chores
  alias ChorizoCore.Entities.Chore

  setup do
    Chores.reset()
    on_exit &Chores.reset/0
  end

  describe "insert/1" do
    test "adds valid %Chore{} to the repository" do
      {:ok, chore} = Chores.insert(Chore.new(name: "wash dishes"))
      assert %Chore{name: "wash dishes"} = chore
      assert {:ok, ^chore} = Chores.first(name: "wash dishes")
    end

    test "does not remove existing chores" do
      {:ok, fred} = Chores.insert(Chore.new(name: "clean room"))
      {:ok, wilma} = Chores.insert(Chore.new(name: "sweep floors"))
      assert {:ok, ^fred} = Chores.first(name: "clean room")
      assert {:ok, ^wilma} = Chores.first(name: "sweep floors")
    end

    test "does not let you add duplicate name" do
      Chores.insert(Chore.new(name: "wash dishes"))
      assert {:error, "attempted to insert duplicate name"} =
        Chores.insert(Chore.new(name: "wash dishes"))
    end
  end

  describe "first/1" do
    test "returns the chore with the matching attribute" do
      {:ok, chore} = Chores.insert(Chore.new(name: "wash dishes"))
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
      assert {:ok, 0} = Chores.count()
      Chores.insert(Chore.new(name: "wash dishes"))
      assert {:ok, 1} = Chores.count()
    end
  end
end
