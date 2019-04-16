defmodule Chorizo.Accounts.VO.User do
  @moduledoc """
  Basic Value struct with fields relevant to application users

  Note that Value modules should contain no business rules. At most they may
  contain functions that validate the type of data being added to each field.
  """

  @type t :: %__MODULE__{
    id: UUID.t(),
    email_address: String.t(),
    password: String.t()
  }
  defstruct [:id, :email_address, :password]
end
