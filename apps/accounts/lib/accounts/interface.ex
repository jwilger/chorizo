defmodule Chorizo.Accounts.Interface do
  @callback create_user(%{email_address: String.t(), password: String.t()}) ::
    {:ok, %{id: UUID.t(), email_address: String.t(), password_hash: String.t()}} |
    {:error, list(String.t())}
end
