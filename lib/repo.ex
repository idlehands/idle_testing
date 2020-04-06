defmodule IdleTesting.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :idle_testing,
    adapter: Ecto.Adapters.Postgres
end
