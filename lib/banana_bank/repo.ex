defmodule BananaBank.Repo do
  use Ecto.Repo,
    otp_app: :banana_bank,
    adapter: Ecto.Adapters.SQLite3
end
