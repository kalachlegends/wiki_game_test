defmodule WikiGameTest.Sorter do
  def sort_list_by_lvl_for_gitler(list) when is_list(list) do
    {:ok, {_, links_sort}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler1")
    {:ok, {_, links_filter}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler-1")

    list
    |> Enum.filter(fn x -> !(x in links_filter) end)
    |> Enum.sort(fn a, b ->
      a in links_sort
    end)
  end
end
