defmodule ChorizoCore.Entities.UserTest do
  use ExUnit.Case, async: true
  import Mox
  alias ChorizoCore.Entities.User
  alias __MODULE__.{MockHasher, MockUUID}

  doctest ChorizoCore.Entities.User


  setup_all do
    defmock(__MODULE__.MockHasher, for: ChorizoCore.Authentication.Hasher)
    defmock(__MODULE__.MockUUID, for: ChorizoCore.Entities.UUID)
    []
  end

  setup :verify_on_exit!

  describe "new/1 when no id is supplied" do
    test "generates a UUID for the user" do
      id = "some-uuid"
      MockUUID
      |> expect(:uuidv4, fn -> id end)
      assert %{id: ^id} = User.new(id_generator: MockUUID)
    end
  end

  describe "new/1 when an id is supplies" do
    test "does not change the id" do
      id = "some-uuid"
      assert %{id: ^id} = User.new(id: id)
    end
  end

  describe "new/1 when no password supplied" do
    test "does not add a hashed password value" do
      assert %{password_hash: nil} = User.new()
    end

    test "does not overwrite an existing password hash" do
      hash = "hashashash"
      assert %{password_hash: ^hash} = User.new(password_hash: hash)
    end
  end

  describe "new/1 when password supplied" do
    test "hashes the password" do
      password = "^L3t^ ^me^ ^1n^ ^here!^"
      hashed_pw = "hashashash"
      MockHasher
      |> expect(:hashpwsalt, fn ^password -> hashed_pw end)

      assert %{password_hash: ^hashed_pw} =
        User.new(password: "^L3t^ ^me^ ^1n^ ^here!^",
                 password_hash: "oldhash",
                 password_hasher: MockHasher)
    end
  end
end
