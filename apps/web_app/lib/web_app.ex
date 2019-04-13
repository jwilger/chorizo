defmodule Chorizo.WebApp do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Chorizo.WebApp, :controller
      use Chorizo.WebApp, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Chorizo.WebApp
      import Plug.Conn
      import Chorizo.WebApp.Gettext
      alias Chorizo.WebApp.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/web_app/templates",
        namespace: Chorizo.WebApp

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Chorizo.WebApp.ErrorHelpers
      import Chorizo.WebApp.Gettext
      alias Chorizo.WebApp.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Chorizo.WebApp.Gettext
    end
  end

  @doc """
  Turns the specified data into a JWT
  """
  def sign_jwt(data) do
    Phoenix.Token.sign(Chorizo.WebApp.Endpoint, jwt_secret(), data)
  end

  @doc """
  Verifies the validity of a JWT
  """
  def verify_jwt(token, options \\ []) do
    Phoenix.Token.verify(Chorizo.WebApp.Endpoint, jwt_secret(), token, options)
  end

  defp jwt_secret do
    System.get_env("JWT_SECRET") ||
      Application.get_env(:web_app, :jwt_secret) ||
      raise "JWT_SECRET environment variable not set"
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
