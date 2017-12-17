defmodule ChorizoCore.Entities.UserTest do
  use ExUnit.Case

  alias ChorizoCore.Entities.User
  doctest User

  describe "changeset/2" do
    defp valid_user_data(%{} = changes) do
      Map.merge(%{username: "bob #{System.unique_integer}"}, changes)
    end

    test "password is hashed when present" do
      orig = valid_user_data(%{password: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute changeset.changes.password_hash == orig.password
    end

    test "password is hashed even when other attributes are invalid" do
      orig = valid_user_data(%{username: "", password: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute [] == changeset.errors
      refute Map.get(changeset.changes, :password_hash) == orig.password
    end

    test "password hashing removes :password" do
      orig = valid_user_data(%{username: "", password: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute Map.has_key?(changeset.changes, :password)
    end

    test "password hashing removes :password_confirmation" do
      orig = valid_user_data(%{username: "", password_confirmation: "Ty#7BDpn"})
      changeset = User.changeset(%User{}, orig)
      refute Map.has_key?(changeset.changes, :password_confirmation)
    end

    test "username is required" do
      changeset = User.changeset(valid_user_data(%{username: nil}))
      assert({:username, {"can't be blank", [validation: :required]}}
             in changeset.errors)
    end

    test "password confirmation must match password if present" do
      data = valid_user_data(%{password: "Ty#7BDpn",
        password_confirmation: "nope"})
      changeset = User.changeset(data)
      expected = {
        :password_confirmation,
        {"does not match confirmation", [validation: :confirmation]}
      }
      assert expected in changeset.errors
    end
  end
end
