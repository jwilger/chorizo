defmodule Chorizo.WebApp.AccountsControllerTest do
  use Chorizo.WebApp.ConnCase

  import Mox

  setup :verify_on_exit!

  describe "create_user/2 with incorrectly formatted parameters" do
    test "responds with a 400 Bad Request status", %{conn: conn} do
      request_params = %{"bad" => "params"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :create_user), %{"bad" => "params"})
        |> json_response(400)

      expected = %{
        "errors" => ["Invalid command parameters in request."],
        "request_params" => request_params
      }

      assert response == expected
    end
  end

  describe "create_user/2 with correctly formatted parameters" do
    @create_user_params %{
      "email_address" => "nobody@example.com",
      "password" => "This is an 0k password, I guess."
    }

    test "uses the Accounts API to create the user", %{conn: conn} do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn %{email_address: "nobody@example.com", password: "This is an 0k password, I guess."} ->
        {:ok, %{id: "59842f3e-0b15-4ab3-9390-5a0e1a32b763", email_address: "nobody@example.com"}}
      end)

      post(conn, Routes.accounts_path(conn, :create_user), @create_user_params)
    end

    test "when account created, renders account as json with 201 status", %{conn: conn} do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn _ ->
        {:ok, %{id: "59842f3e-0b15-4ab3-9390-5a0e1a32b763", email_address: "nobody@example.com"}}
      end)

      result =
        conn
        |> post(Routes.accounts_path(conn, :create_user), @create_user_params)
        |> json_response(201)

      assert result == %{
        "id" => "59842f3e-0b15-4ab3-9390-5a0e1a32b763",
        "email_address" => "nobody@example.com"
      }
    end

    test "when account creation fails, renders errors with 422 status", %{conn: conn} do
      Chorizo.Accounts.Mock
      |> expect(:create_user, fn _ -> {:error, ["reason 1", "reason 2"]} end)

      result =
        conn
        |> post(Routes.accounts_path(conn, :create_user), @create_user_params)
        |> json_response(422)

      assert result == %{
        "errors" => ["reason 1", "reason 2"],
        "request_params" => @create_user_params
      }
    end
  end
end
