defmodule ChorizoCore.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chorizo_core,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
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
      {:mox, "~> 0.3", only: :test},
      {:ex_doc, "~> 0.16", only: :dev},
      {:uuid, "~> 1.1"}
    ]
  end
end
