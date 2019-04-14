defmodule Chorizo.WebApp.Resolvers.User do
  @moduledoc """
  Resolver used by `Absinthe` for GraphQL queries/mutations on users
  """
  @accounts_api Application.get_env(:web_app, :accounts_api, Chorizo.Accounts)

  alias Chorizo.Accounts

  @doc """
  Creates a new user account
  """
  def create_user(%{email_address: email_address, password: password}, _) do
    %Accounts.VO.User{email_address: email_address, password: password}
    |> @accounts_api.create_user
    |> case do
      {:error, _} = result -> result
      {:ok, user} -> {:ok, %{user: user, jwt: jwt(user)}}
    end
  end

  defp jwt(user) do
    {:ok, token, _claims} = Chorizo.WebApp.Guardian.encode_and_sign(user)
    token
  end
end
