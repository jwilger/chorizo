# Since configuration is shared in umbrella projects, this file
# should only configure the :web_app application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :web_app,
  namespace: Chorizo.WebApp,
  generators: [context_app: false]

config :phoenix, :json_library, Jason

# Configures the endpoint
config :web_app, Chorizo.WebApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "K4Sn/ytwt7akdhFgx6FFi67ByQKySMuLTDKI8+Rjz641x2kE23umeaUBO5Xp6EYw",
  render_errors: [view: Chorizo.WebApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chorizo.WebApp.PubSub, adapter: Phoenix.PubSub.PG2]

config :web_app, Chorizo.WebApp.Guardian,
  issuer: "web_app",
  secret_key: {:system, "JWT_SECRET"},
  secret_fetcher: Chorizo.WebApp.Guardian.SecretFetcher

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
