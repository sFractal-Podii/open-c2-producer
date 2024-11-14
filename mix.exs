defmodule OpencC2Test.MixProject do
  use Mix.Project

  def project do
    [
      app: :openc_c2_test,
      version: "0.5.1",
      elixir: "~> 1.17.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {OpencC2Test.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :ueberauth_github,
        :ueberauth
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_ecto, "~> 4.6"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.5", only: :dev},
      {:phoenix_live_view, "~> 0.20.17"},
      {:floki, ">= 0.36.3", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.4"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.17.3"},
      {:finch, "~> 0.19"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.1"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.7"},
      {:oauth2, "~> 2.0", override: true},
      {:ueberauth, "~> 0.10.8"},
      {:ueberauth_github, "~> 0.8.1"},
      {
        :sbom,
        #  only: :dev,
        git: "https://github.com/sigu/sbom.git", branch: "auto-install-bom", runtime: false
      },
      {:ranch, ">= 0.0.0", manager: :rebar3, override: true},
      {:emqtt, github: "emqx/emqtt", tag: "1.13.3", system_env: [{"BUILD_WITHOUT_QUIC", "1"}]},
      {:cowlib, "~> 2.13.0", override: true},
      {:gun, "~> 2.1.0", override: true},
      {:phoenix_html_helpers, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
