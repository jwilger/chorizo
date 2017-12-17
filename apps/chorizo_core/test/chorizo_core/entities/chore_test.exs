defmodule ChorizoCore.Entities.ChoreTest do
  use ExUnit.Case

  alias ChorizoCore.Entities.Chore
  doctest Chore

  describe "changeset/2" do
    defp valid_chore_data(%{} = changes \\ %{}) do
      Map.merge(%{name: "Clean Room #{System.unique_integer}"}, changes)
    end

    test "returns a changeset with no errors when data is valid" do
      changeset = Chore.changeset(valid_chore_data())
      assert [] = changeset.errors
    end

    test "name is required" do
      changeset = Chore.changeset(valid_chore_data(%{name: nil}))
      assert({:name, {"can't be blank", [validation: :required]}}
             in changeset.errors)
    end
  end
end
