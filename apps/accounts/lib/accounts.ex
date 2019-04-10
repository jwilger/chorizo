defmodule Chorizo.Accounts do
  @moduledoc """
  Provides the public API for the Accounts bounded-context
  """

  @behaviour Chorizo.Accounts.Interface

  @doc """
  Creates a new instance of the User aggregate.

  *This functionality is not currently implemented.*

  ## Examples

      iex> Chorizo.Accounts.create_user(%{email_address: "nobody@example.com", password: "This is an 0k password, I guess."})
      {:error, ["The create_user/2 API is reserved but has not yet been implemented."]}
  """
  def create_user(_user_attrs) do
    {:error, ["The create_user/2 API is reserved but has not yet been implemented."]}
  end
end
