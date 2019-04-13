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
    @desc "Creates a new user"
    field :create_user, type: :create_user_response do
      arg :email_address, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.User.create_user/2
    end
  end


  object :create_user_response do
    @desc "The attributes for the user that was just created"
    field :user, non_null(:user)

    @desc "A JWT that can be used to authenticate the user for further API requests"
    field :jwt, non_null(:string)
  end

  object :user do
    field :id, non_null(:id)
    field :email_address, non_null(:string)
  end
end
