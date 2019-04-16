# Since configuration is shared in umbrella projects, this file
# should only configure the :accounts application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :accounts, Chorizo.Accounts.Repo,
  url: "ecto://localhost/chorizo_accounts_test",
  pool: Ecto.Adapters.SQL.Sandbox
