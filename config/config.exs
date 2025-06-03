# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :openc_c2_test,
  ecto_repos: [OpencC2Test.Repo]

# Configures the endpoint
config :openc_c2_test, OpencC2TestWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: OpencC2TestWeb.ErrorHTML, json: OpencC2TestWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: OpencC2Test.PubSub,
  live_view: [signing_salt: "tdtsUA9R"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :openc_c2_test, OpencC2Test.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Github authentication configuration
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "",
  client_secret: ""

rand_suffix = :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)

config :openc_c2_test, OpencC2Test.Emqtt.Emqx,
  host: ~c"#{System.fetch_env!("MQTT_HOST")}",
  port: String.to_integer(System.fetch_env!("MQTT_PORT")),
  client_id: System.fetch_env!("CLIENT_ID") <> rand_suffix,
  clean_start: false

rand_suffix = :crypto.strong_rand_bytes(4) |> Base.encode16(case: :lower)

config :openc_c2_test, OpencC2Test.Emqtt.Hivemq,
  client_id: System.fetch_env!("HIVEMQ_CLIENT_ID") <> rand_suffix,
  host: ~c"#{System.fetch_env!("HIVEMQ_HOST")}",
  port: String.to_integer(System.fetch_env!("HIVEMQ_PORT")),
  clean_start: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
