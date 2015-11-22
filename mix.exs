defmodule MebeWeb.Mixfile do
  use Mix.Project

  def project do
    [app: :mebe_web,
     version: "1.0.0",
     deps_path: "deps",
     lockfile: "mix.lock",
     elixir: "~> 1.1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {MebeWeb, []},
     applications: [:phoenix, :cowboy, :logger]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_html, "~> 2.2"},
      {:cowboy, "~> 1.0"},
      {:earmark, "~> 0.1.16"}
   ]
  end
end
