defmodule ChorizoCore.Entities.UserTest do
  use ExUnit.Case, async: true
  doctest ChorizoCore.Entities.User

  alias ChorizoCore.Entities.User

  describe "anonymous!/0" do
    test "returns an anonymous %User{}" do
      assert %User{username: "", anonymous: true} = User.anonymous!
    end
  end

  describe "new/1" do
    test "with valid properties returns a %User{}" do
      assert %User{
        username: "bob",
        anonymous: false
      } = User.new(username: "bob")
    end
  end
end
