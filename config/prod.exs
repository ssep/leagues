use Mix.Config

config :fluxter,
  host: "influxdb",
  port: 4444,
  pool_size: 10

config :logger, level: :info
