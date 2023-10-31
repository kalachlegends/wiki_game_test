defmodule WikiGameTest.Repo do
  use Ecto.Repo,
    otp_app: :wiki_game_test,
    adapter: Ecto.Adapters.Postgres
end
