defmodule WikiGameTest.Scrapper.Starter do
  alias WikiGameTest.HistoryLinks
  alias WikiGameTest.Scrapper
  alias WikiGameTest.Config.Main, as: ConfigMain

  def start_lvl_0() do
    adolf_link = ConfigMain.get_adolf_gilter_link()

    with {:ok, links_from_adolf} <- Scrapper.get_links_from_page_link(adolf_link) do
      links_from_adolf
      |> Enum.each(fn x_link ->
        HistoryLinks.update_or_create(%{link: x_link}, %{link: x_link, lvl_to_gitler: 0})
      end)
    end
  end
end
