defmodule WikiGameTest.Config.Main do
  def get_adolf_gilter_link() do
    Application.get_env(:wiki_game_test, :adolf_link)
  end

  def get_word_of_war() do
    Application.get_env(:wiki_game_test, :word_of_war_link)
  end
end
