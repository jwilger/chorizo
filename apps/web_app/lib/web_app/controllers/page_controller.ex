defmodule Chorizo.WebApp.PageController do
  use Chorizo.WebApp, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
