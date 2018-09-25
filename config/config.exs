# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :leagues, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:leagues, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

import_config "#{Mix.env}.exs"

config :leagues, Leagues.Http.Server,
  adapter: Plug.Adapters.Cowboy2,
  plug: Leagues.Http,
  scheme: :http,
  ip: {0, 0, 0, 0},
  port: 8080

config :leagues,
  maru_servers: [Leagues.Http.Server],
  scores_filename_csv: "data.csv"

config :maru, Leagues.Http,
  versioning: [
    using: :path
  ]

 config :vmstats,
  sink: Leagues.Metrics,
  interval: 3000 #ms

config :logger, level: :debug
