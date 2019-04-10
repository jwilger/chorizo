defmodule Chorizo.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Chorizo",
      source_url: "https://github.com/jwilger/chorizo",
      homepage_url: "http://johnwilger.com/chorizo/",
      docs: [
        main: "readme",
        extras: ["README.md"],
        output: "docs"
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
      {:ex_doc, "~> 0.20", only: :dev, runtime: false}
    ]
  end
end
