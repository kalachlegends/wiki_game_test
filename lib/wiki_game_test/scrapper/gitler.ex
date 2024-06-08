defmodule WikiGameTest.Gitler do
  def search_gitler(page) do
    search_gitler(replace_to_normal(page), [])
  end

  def replace_to_normal(str) do
    String.replace(str, WikiGameTest.Wikipedia.host_url(), "")
  end

  def search_gitler(page, from_pages) when is_binary(page) do
    with {:ok, links} <-
           WikiGameTest.Scrapper.get_links_from_page_link(page) do
      adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

      word_war_link = WikiGameTest.Config.Main.get_word_of_war()
      {:ok, {_, lvl_to_giltler0}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler0")

      cond do
        adolf_gitler in links ->
          {:ok, [adolf_gitler | from_pages]}

        page in lvl_to_giltler0 ->
          {:ok, [page | from_pages]}

        word_war_link in links ->
          {:ok, [adolf_gitler, word_war_link] ++ from_pages}

        true ->
          WikiGameTest.Ets.Cache.push_lvl_to_gitler(-1, page)
          search_gitler(links, from_pages)
      end
    else
      _any -> {:error, :not_found}
    end
  end

  def search_gitler(list, from_pages) do
    page = WikiGameTest.Sorter.sort_list_by_lvl_for_gitler(list) |> List.first()
    search_gitler(page, [page | from_pages])
  end

 
end
