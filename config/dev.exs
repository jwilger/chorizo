use Mix.Config

config :chorizo_core, ChorizoCore.Repositories.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "chorizo_dev",
  hostname: "localhost"
