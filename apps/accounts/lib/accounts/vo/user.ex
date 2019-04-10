defmodule Chorizo.Accounts.VO.User do
  @type t :: %__MODULE__{
    id: UUID.t(),
    email_address: String.t(),
    password: String.t()
  }
  defstruct [:id, :email_address, :password]
end
