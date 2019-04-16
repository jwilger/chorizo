# Since configuration is shared in umbrella projects, this file
# should only configure the :accounts application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :accounts,
  namespace: Chorizo.Accounts,
  ecto_repos: [Chorizo.Accounts.Repo]

import_config "#{Mix.env()}.exs"
