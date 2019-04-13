defmodule Chorizo.WebApp.Router do
  use Chorizo.WebApp, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Chorizo.WebApp.Guardian.Pipeline
    plug Chorizo.WebApp.AbsintheContext
  end

  scope "/", Chorizo.WebApp do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through [:api, :auth]

    forward "/", Absinthe.Plug,
      schema: Chorizo.WebApp.Schema
  end

  scope "/graphiql" do
    pipe_through [:api, :auth]
    forward "/", Absinthe.Plug.GraphiQL,
      schema: Chorizo.WebApp.Schema,
      interface: :simple
  end
end
