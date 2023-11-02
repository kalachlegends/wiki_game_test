defmodule WikiGameTest.Gitler do
  def search_gitler(page) do
    search_gitler(page, [])
  end

  def search_gitler(page, from_pages) when is_binary(page) do
    with {:ok, links} <-
           WikiGameTest.Scrapper.get_links_from_page_link(page) do
      adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

      word_war_link = WikiGameTest.Config.Main.get_word_of_war()

      cond do
        adolf_gitler in links ->
          from_pages

        word_war_link in links ->
          [word_war_link | from_pages]

        true ->
          WikiGameTest.Ets.Cache.push_lvl_to_gitler(-1, page)
          search_gitler(links, from_pages)
      end
    else
      any -> {:error, :not_found}
    end
  end

  def search_gitler(list, from_pages) do
    page = WikiGameTest.Sorter.sort_list_by_lvl_for_gitler(list) |> List.first()
    search_gitler(page, [page | from_pages])
  end

  # def search_gitler(links, from_pages, old_page) when is_list(links) do
  #   adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

  #   cond do
  #     adolf_gitler in links ->
  #       from_pages

  #     true ->
  #       WikiGameTest.Ets.Cache.push_filter_list_without_gitler(old_page)
  #       {:ok, {_, list_filter}} = WikiGameTest.Ets.Cache.get("filter_list_without_gitler")
  #       # IO.inspect(list_filter)

  #       Enum.filter(links, fn x -> !(x in list_filter) end)
  #       |> do_seach_gilter(from_pages)
  #   end
  # end

  # defp do_seach_gilter([x_link | t], from_pages) do
  #   adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()
  #   {:ok, {_, list_to_gitler_lvl_0}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler0")

  #   with {:ok, new_links} <- WikiGameTest.Wikipedia.get(x_link) do
  #     cond do
  #       adolf_gitler == x_link ->
  #         from_pages

  #       x_link in list_to_gitler_lvl_0 ->
  #         [x_link | from_pages]

  #       true ->
  #         do_seach_gilter(t, from_pages)
  #     end
  #   end
  # end

  # def search_gitler([page | t]) do

  # end
  # def search_gitler(%{page_check => [%{page=> [list]} | list_pages]}, from_pages, current_page_list) do
  #   {:ok, {_, list_to_gitler_lvl_0}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler0")
  #   adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

  #   cond do
  #     page in list_to_gitler_lvl_0 ->
  #       # IO.inspect(list_to_gitler_lvl_0, label: "from_pages")
  #       [page|from_pages]

  #     page != adolf_gitler ->
  #       with {:ok, links} <-
  #              WikiGameTest.Scrapper.get_links_from_page_link(page) do
  #         {:ok, {_, list_filter}} = WikiGameTest.Ets.Cache.get("filter_list_without_gitler")
  #         links = Enum.filter(links, fn x -> !(x in list_filter) end)

  #         cond do
  #           adolf_gitler in links ->
  #             from_pages

  #           true ->
  #             WikiGameTest.Ets.Cache.push_filter_list_without_gitler(page)
  #             search_gitler(t ++ links, put_in(current_page_list, nil), current_page_list)
  #         end
  #       end

  #     true ->
  #       from_pages
  #   end
  # end
end
