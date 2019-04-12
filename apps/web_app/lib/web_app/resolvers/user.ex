defmodule Chorizo.WebApp.Resolvers.User do
  @accounts_api Application.get_env(:web_app, :accounts_api, Chorizo.Accounts)

  alias Chorizo.Accounts
  def create_user(%{email_address: email_address, password: password}, _) do
    %Accounts.VO.User{email_address: email_address, password: password}
    |> @accounts_api.create_user
  end
end
