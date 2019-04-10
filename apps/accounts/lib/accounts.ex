defmodule Chorizo.Accounts do
  @on_definition Chorizo.PublicApiHooks

  @moduledoc """
  Provides the public API for the Accounts bounded-context

  Note that all public functions are also defined as callbacks, so that this
  module can be used as a `Behaviour` (particularly useful for mocking this
  interface in the test suites of other applications.)
  """

  alias Chorizo.Accounts.VO

  @doc """
  Creates a new instance of the User aggregate.

  *This functionality is not currently implemented.*

  ## Examples

      iex> alias Chorizo.Accounts.VO.User
      iex> Chorizo.Accounts.create_user(%User{email_address: "nobody@example.com", password: "This is an 0k password, I guess."})
      {:error, ["The create_user/2 API is reserved but has not yet been implemented."]}
  """
  @spec create_user(
    user :: VO.User.t(:email_address, :password)
  ) :: {:ok, VO.User.t} | {:error, [String.t,...]}
  def create_user(%VO.User{}) do
    {:error, ["The create_user/2 API is reserved but has not yet been implemented."]}
  end
end
