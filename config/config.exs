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


config :code_fishbowl, :languages,
  [
    "JavaScript": "javascript",
    "C": "c_cpp",
    "C++": "c_cpp",
    "C#": "csharp",
    "Clojure": "clojure",
    "CSS": "css",
    "Elixir": "elixir",
    "Elm": "elm",
    "Erlang": "erlang",
    "Go": "golang",
    "Haskell": "haskell",
    "HTML": "html",
    "Java": "java",
    "JSON": "json",
    "JSX": "jsx",
    "Kotlin": "kotlin",
    "LaTeX": "latex",
    "Lisp": "lisp",
    "Markdown": "markdown",
    "ObjectiveC": "objectivec",
    "OCaml": "ocaml",
    "Perl": "perl",
    "PHP": "php",
    "Protobuf": "protobuf",
    "Python": "python",
    "R": "r",
    "Ruby": "ruby",
    "Rust": "rust",
    "SASS": "sass",
    "Scala": "scala",
    "Scheme": "scheme",
    "SCSS": "scss",
    "SH": "sh",
    "SQL": "sql",
    "Swift": "swift",
    "Text": "text",
    "Typescript": "typescript",
    "XML": "xml",
    "YAML": "yaml"
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
