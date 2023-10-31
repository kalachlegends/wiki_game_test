defmodule WikiGameTest.Config.Main do
  def get_adolf_gilter_link() do
    Application.get_env(:wiki_game_test, :adolf_link)
  end
end
