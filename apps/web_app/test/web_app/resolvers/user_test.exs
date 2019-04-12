defmodule Chorizo.WebApp.Resolvers.UserTest do
  use Chorizo.WebApp.ConnCase

  alias Chorizo.WebApp.Resolvers.User

  import Mox

  setup :verify_on_exit!

  describe "create_user/2" do
    test "calls Accounts.create_user/2 with the supplied arguments" do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn %Chorizo.Accounts.VO.User{} = user ->
        {:ok, %Chorizo.Accounts.VO.User{
          id: "e93c98b2-628f-4617-a159-14b492156c9f",
          email_address: user.email_address
        }}
      end)

      User.create_user("nobody@example.com", "foobarbaz")
    end

    test "returns the {:ok, user} tuple when successful" do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn user ->
        {:ok, %Chorizo.Accounts.VO.User{
          id: "e93c98b2-628f-4617-a159-14b492156c9f",
          email_address: user.email_address
        }}
      end)

      {:ok, %{id: user_id, email_address: email_address}} =
        User.create_user("nobody@example.com", "foobarbaz")

      assert "e93c98b2-628f-4617-a159-14b492156c9f" == user_id
      assert "nobody@example.com" == email_address
    end

    test "returns the {:error, messages} tuple when an error occurs" do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn _ ->
        {:error, ["Something happened"]}
      end)

      assert {:error, ["Something happened"]} == 
        User.create_user("nobody@example.com", "foobarbaz")
    end
  end
end
