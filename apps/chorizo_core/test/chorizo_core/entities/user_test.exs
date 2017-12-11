defmodule ChorizoCore.Entities.UserTest do
  use ExUnit.Case

  alias ChorizoCore.Entities.User
  doctest User

  describe "changeset/2" do
    defp valid_user_data(%{} = changes) do
      %{username: "bob #{System.unique_integer}"}
      |> Map.merge(changes)
    end

    test "password is hashed when present" do
      orig = valid_user_data(%{password: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute changeset.changes.password_hash == orig.password
      refute Map.has_key?(changeset.changes, :password)
    end

    test "password is hashed even when other attributes are invalid" do
      orig = valid_user_data(%{username: "", password: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute [] == changeset.errors
      refute Map.get(changeset.changes, :password_hash) == orig.password
      refute Map.has_key?(changeset.changes, :password)
    end

    test "username is required" do
      changeset = User.changeset(valid_user_data(%{username: nil}))
      assert({:username, {"can't be blank", [validation: :required]}}
             in changeset.errors)
    end
  end
end
