defmodule Chorizo.WebApp.AbsintheContext do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    %{current_user: Guardian.Plug.current_resource(conn)}
  end
end
