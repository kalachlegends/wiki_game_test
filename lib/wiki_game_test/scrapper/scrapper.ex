defmodule WikiGameTest.Scrapper do
  require Logger

  def get_links_from_page_link(page) do
    with {:ok, %{body: body}} <- WikiGameTest.Wikipedia.get(page) do
      {:ok, html} = Floki.parse_document(body)
      Logger.info("SUCCEFULL PARSING #{page}")

      {:ok,
       Floki.find(html, ".mw-parser-output")
       |> Floki.find("a[href=*=\"/wiki]")
       |> Floki.attribute("a", "href")
       |> Enum.filter(&is_valid_link(&1))}
    end
  end

  def search_gitler(page) do
    with {:ok, links} <-
           WikiGameTest.Scrapper.get_links_from_page_link(page) do
      adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

      cond do
        adolf_gitler in links -> [page]
        true -> search_gitler(links, %{page => %{}}, page)
      end
    end
  end

  def search_gitler([page | t], from_pages, original_page) do
    {:ok, {_, list_to_gitler_lvl_0}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler0")
    adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

    cond do
      page in list_to_gitler_lvl_0 ->
        # IO.inspect(list_to_gitler_lvl_0, label: "from_pages")
        [page | from_pages]

      page != adolf_gitler ->
        {:ok, list_filter} = WikiGameTest.Ets.Cache.push_filter_list_without_gitler(page)

        with {:ok, links} <-
               WikiGameTest.Scrapper.get_links_from_page_link(page) do
          links = Enum.filter(links, fn x -> !(x in list_filter) end)

          cond do
            adolf_gitler in links -> from_pages
            true -> search_gitler(t ++ links, from_pages, original_page)
          end
        end

      true ->
        from_pages
    end
  end

  defp is_valid_link(string) do
    !Regex.match?(~r/(File:|\/\/upload|#|:|https)/, string)
  end
end
