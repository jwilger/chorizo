use Mix.Config

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

config :chorizo_core, ChorizoCore.Repositories.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "chorizo_test",
  hostname: "localhost",
  username: "chorizo"
