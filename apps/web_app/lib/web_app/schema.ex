defmodule Chorizo.WebApp.Schema do
  use Absinthe.Schema

  alias Chorizo.WebApp.Resolvers

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve fn _, _, _ ->
        {:ok, []}
      end
    end
  end

  mutation do
    @dec "Creates a new user"
    field :create_user, type: :user do
      arg :email_address, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.User.create_user/2
    end
  end

  object :user do
    field :id, non_null(:id)
    field :email_address, non_null(:string)
  end
end
