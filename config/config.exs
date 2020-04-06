use Mix.Config

config :idle_testing,
  ecto_repos: [IdleTesting.Repo],
  generators: [binary_id: true]

config :idle_testing, IdleTesting.Repo,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASS") || "postgres",
  database: "idle_testing",
  hostname: System.get_env("PGHOST") || "localhost",
  port: System.get_env("PGPORT") || "5432",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_timestamps: [type: :utc_datetime_usec],
  ownership_timeout: :infinity

import_config "#{Mix.env()}.exs"
