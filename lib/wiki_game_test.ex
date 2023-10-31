defmodule WikiGameTest do
  @moduledoc """
  WikiGameTest keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_links_from_page(page) do
    with {:ok, %{body: body}} <- WikiGameTest.Wikipedia.get(page) do
      {:ok, html} = Floki.parse_document(body)

      {:ok,
       Floki.find(html, ".mw-parser-output")
       |> Floki.find("a[href=*=\"wiki]")
       |> Floki.attribute("a", "href")
       |> Enum.filter(&is_valid_link(&1))}
    end
  end

  def recursive() do
    recursive("wiki/Kazakhstan", [])
  end

  def recursive(page, acc) do
    links = get_links_from_page(page)

    result =
      links
      |> Enum.find(fn x -> x == "/wiki/Adolf_Hitler" end)

    if result != nil do
      [page | acc]
    else
      Enum.map(links, fn page_item -> recursive(page_item, [page | acc]) end)
    end
  end

  def is_valid_link(string) do
    !Regex.match?(~r/(File:|\/\/upload|#|Help:|:EditPage)/, string)
  end
end
