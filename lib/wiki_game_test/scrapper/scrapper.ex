defmodule WikiGameTest.Scrapper do
  require Logger

  def get_links_from_page_link(page) do
    with {:ok, %{body: body}} <- WikiGameTest.Wikipedia.get(page) do
      {:ok, html} = Floki.parse_document(body)
      Logger.info("SUCCEFULL PARSING #{page}")

      {:ok,
       Floki.find(html, ".mw-parser-output")
       |> Floki.find("a[href=*=wiki]")
       |> Floki.attribute("a", "href")
       |> Enum.uniq()
       |> Enum.filter(&is_valid_link(&1))}
    end
  end

  def get_coutries() do
    with {:ok, %{body: body}} <-
           WikiGameTest.Wikipedia.get("/wiki/List_of_countries_and_dependencies_by_population") do
      {:ok, html} = Floki.parse_document(body)

      {:ok,
       Floki.find(html, ".wikitable")
       |> Floki.find("a[href=*=wiki]")
       |> Floki.attribute("a", "href")
       |> Enum.uniq()
       |> Enum.filter(&is_valid_link(&1))}
    end
  end

  defp is_valid_link(string) do
    !Regex.match?(~r/(File:|\/\/upload|#|:|https)/, string)
  end
end
