defmodule Chorizo.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),

      # Docs
      name: "Chorizo",
      source_url: "https://github.com/jwilger/chorizo_core",
      homepage_url: "http://johnwilger.com/chorizo_core",
      docs: [
        main: "readme",
        extras: ["README.md": [filename: "readme", title: "README"]]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 0.8", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:dogma, "~> 0.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.16", only: :dev},
    ]
  end

  defp aliases do
    [
      "compile":    ["compile --warnings-as-errors"]
    ]
  end
end
