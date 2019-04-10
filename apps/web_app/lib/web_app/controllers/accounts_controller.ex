defmodule Chorizo.WebApp.AccountsController do
  use Chorizo.WebApp, :controller

  alias Chorizo.Accounts.VO.User

  @accounts_api Application.get_env(:web_app, :accounts_api, Chorizo.Accounts)

  def create_user(conn, %{"email_address" => email_address, "password" => password} = params)
    when is_binary(email_address) and is_binary(password)
  do
    %User{email_address: email_address, password: password}
    |> @accounts_api.create_user()
    |> case do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> json(user)
      {:error, messages} ->
        conn
        |> put_status(422)
        |> json(%{errors: messages, request_params: params})
    end
  end

  def create_user(conn, params) do
    conn
    |> put_status(400)
    |> json(%{
      errors: ["Invalid command parameters in request."],
      request_params: params
    })
  end
end
