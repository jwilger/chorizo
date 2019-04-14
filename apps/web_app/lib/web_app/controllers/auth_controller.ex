defmodule Chorizo.WebApp.AuthController do
  use Chorizo.WebApp, :controller

  @accounts_api Application.get_env(:web_app, :accounts_api, Chorizo.Accounts)

  alias Chorizo.Accounts.VO.User

  def token(conn,
    %{"grant_type" => "password",
      "username" => email_address,
      "password" => password})
  do
    %User{email_address: email_address, password: password}
    |> @accounts_api.authenticate_user
    |> case do
      {:ok, user} -> send_token(conn, user)
      {:error, _} -> send_authentication_failure(conn)
    end
  end

  def token(conn, _) do
    conn
    |> put_status(400)
    |> json(%{
      error: "unsupported_grant_type",
      error_description: """
        This OAuth server supports the following grant types: 'password'
        """
    })
  end

  defp send_token(conn, user) do
    {:ok, token, _claims} = Chorizo.WebApp.Guardian.encode_and_sign(user)
    conn
    |> json(%{
      access_token: token,
      token_type: "bearer",
      expires_in: Chorizo.WebApp.Guardian.expires_in_seconds()
    })
  end

  defp send_authentication_failure(conn) do
    conn
    |> put_status(401)
    |> json(%{
      error: "invalid_client",
      error_description: "Authentication Failed"
    })
  end
end
