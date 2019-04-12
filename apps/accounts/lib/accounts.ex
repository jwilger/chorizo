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

  ### Successful User Creation

  When called with valid user attributes, the return value will be a tuple
  consisting of the :ok atom and a `Chorizo.Accounts.VO.User` struct with the
  `:id` attribute set to a valid `UUID` value. The password used to create the
  account will not be in the return value.

      iex> alias Chorizo.Accounts.VO.User
      iex> {:ok, %User{} = user} = 
      ...>   Chorizo.Accounts.create_user(%User{
      ...>     email_address: "nobody@example.com",
      ...>     password: "This is an 0k password, I guess."
      ...> })
      iex> {:ok, _uuid} = UUID.info(user.id)
      iex> user.email_address
      "nobody@example.com"
      iex> user.password
      nil

  ### Failed User Creation
  
  If the user cannot be created, the return value will be a tuple consisting of
  the :error atom and a list of error message strings.

      iex> alias Chorizo.Accounts.VO.User
      iex> {:error, messages} = Chorizo.Accounts.create_user(%User{})
      iex> is_list(messages)
      true
  """
  @spec create_user(
    user :: VO.User.t(:email_address, :password)
  ) :: {:ok, VO.User.t} | {:error, [String.t,...]}
  def create_user(%VO.User{} = user) do
    case user do
      %VO.User{password: nil, email_address: nil} ->
        {:error, ["Cannot have empty User Struct"]}
      %VO.User{password: _, email_address: email_address} ->
        {:ok, %VO.User{email_address: email_address, id: UUID.uuid4(:hex)}}
    end
  end
end
