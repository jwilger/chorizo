defmodule ChorizoCore.Entities.UserTest do
  use ExUnit.Case

  alias ChorizoCore.Entities.User
  doctest User

  describe "changeset/2" do
    test "password is hashed when present" do
      orig = %{password: "Ty#7BDpn"}
      changeset = User.changeset(%User{}, orig)
      refute changeset.changes.password_hash == orig.password
      refute Map.has_key?(changeset.changes, :password)
    end
  end
end
