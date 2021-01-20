defmodule PersistConfig.MixProject do
  use Mix.Project

  def project do
    [
      app: :persist_config,
      version: "0.4.16",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      name: "Persist Config",
      source_url: source_url(),
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/persist_config"
  end

  defp description do
    """
    Persists configurations from given files at compile time.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
