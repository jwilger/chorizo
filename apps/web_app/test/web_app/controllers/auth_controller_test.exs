defmodule Chorizo.WebApp.AuthControllerTest do
  use Chorizo.WebApp.ConnCase

  import Mox

  alias Chorizo.Accounts.VO

  setup :verify_on_exit!

  describe "POST /auth/token using non-password grant" do
    test "responds with invalid grant type error", %{conn: conn} do
      %{"error" => error, "error_description" => description} =
        conn
        |> post(Routes.auth_path(conn, :token, %{}))
        |> json_response(400)
      assert error == "unsupported_grant_type"
      assert description == """
        This OAuth server supports the following grant types: 'password'
        """
    end
  end

  describe "POST /auth/token using password grant" do
    test "validates credentials with the Accounts app", %{conn: conn} do
      user_id = "2462d6aa-bcc6-4943-b65f-a1ba80255998"
      email_address = "nobody@example.com"
      password = "This is an 0k password, I guess."

      Chorizo.Accounts.Mock
      |> expect(:authenticate_user,
        fn %{email_address: ^email_address, password: ^password} ->
          {:ok, %VO.User{id: user_id}}
        end)

      conn
      |> post(Routes.auth_path(conn, :token), %{
        "grant_type" => "password",
        "username" => email_address,
        "password" => password
      })
    end
  end

  describe "POST /auth/token with valid credentials" do
    setup %{conn: conn} do
      Chorizo.Accounts.Mock
      |> stub(:authenticate_user, fn _ ->
        {:ok, %VO.User{id: "1234"}}
      end)

      response =
        conn
        |> post(Routes.auth_path(conn, :token), %{
          "grant_type" => "password",
          "username" => "nobody@example.com",
          "password" => "valid password"
        })
        |> json_response(200)

      {:ok, %{response: response}}
    end

    test "responds with an access token for the user", %{response: response} do
      %{"access_token" => token} = response
      {:ok, claims} = Chorizo.WebApp.Guardian.decode_and_verify(token)
      assert {:ok, "1234"} == Map.fetch(claims, "sub")
    end

    test "responds with the token type that was issued", %{response: response} do
      %{"token_type" => type} = response
      assert type == "bearer"
    end

    test "responds with the token expiration time", %{response: response} do
      %{"expires_in" => expires_in} = response
      assert expires_in == Chorizo.WebApp.Guardian.expires_in_seconds()
    end

    test "token actually expires around expiration_time", %{response: response} do
      %{"expires_in" => expires_in, "access_token" => token} = response
      {:ok, claims} = Chorizo.WebApp.Guardian.decode_and_verify(token)
      {:ok, exp} = Map.fetch(claims, "exp")
      calculated_expiration = expires_in + System.system_time(:second)
      assert (calculated_expiration - exp) == 0
    end
  end

  describe "POST /auth/token with invalid credentials" do
    setup %{conn: conn} do
      Chorizo.Accounts.Mock
      |> stub(:authenticate_user, fn _ ->
        {:error, :authentication_failed}
      end)

      response =
        conn
        |> post(Routes.auth_path(conn, :token), %{
          "grant_type" => "password",
          "username" => "nobody@example.com",
          "password" => "invalid password"
        })
        |> json_response(401)

      {:ok, %{response: response}}
    end

    test "responds with an invalid_client error", %{response: response} do
      %{"error" => error, "error_description" => description} = response
      assert error == "invalid_client"
      assert description == "Authentication Failed"
    end
  end
end
