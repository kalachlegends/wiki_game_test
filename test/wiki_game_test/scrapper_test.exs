defmodule WikiGameTest.ScrapperTest do
  use WikiGameTest.DataCase

  test "GET LINKS FROM PAGES" do
    assert {:ok, links} = WikiGameTest.Scrapper.get_links_from_page_link("wiki/Dog")
    assert String.contains?(links |> hd(), "wiki")
  end

  test "GET SOME COUNTRIES" do
    assert {:ok, links} = WikiGameTest.Scrapper.get_coutries()
    assert String.contains?(links |> hd(), "wiki")
    assert !is_nil(Enum.find(links, fn x -> x == "/wiki/Russia" end))
  end
end
