defmodule OpenC2Producer.Repo do
  use Ecto.Repo,
    otp_app: :open_c2_producer,
    adapter: Ecto.Adapters.Postgres
end
