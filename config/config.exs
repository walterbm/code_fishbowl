# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :code_fishbowl, CodeFishbowl.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5h7/+l7M2t3RBeZadPL1bMJHeHEZ+Ygg3uLprsCPq5nksn0W1bmceknVlWcAJcbl",
  render_errors: [view: CodeFishbowl.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CodeFishbowl.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
