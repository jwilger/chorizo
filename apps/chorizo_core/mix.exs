defmodule ChorizoCore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chorizo_core,
      version: "0.1.0-dev",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),

      # Docs
      name: "ChorizoCore",
      source_url: "https://github.com/jwilger/chorizo_core",
      homepage_url: "http://johnwilger.com/chorizo_core",
      docs: [
        main: "readme",
        extras: ["README.md": [filename: "readme", title: "README"]]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ChorizoCore.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:argon2_elixir, "~> 1.2"},
      {:comeonin, "~> 4.0"},
      {:ecto, "~> 2.0"},
      {:mox, "~> 0.3", only: :test},
      {:postgrex, "~> 0.11"},
      {:uuid, "~> 1.1"},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test":       ["ecto.reset", "test"],
    ]
  end
end