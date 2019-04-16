# Since configuration is shared in umbrella projects, this file
# should only configure the :web_app application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_app, Chorizo.WebApp.Endpoint,
  http: [port: 4002],
  server: false

config :web_app, :accounts_api, Chorizo.Accounts.Mock

config :web_app, Chorizo.WebApp.Guardian,
  secret_key: "Not very secret, really"
