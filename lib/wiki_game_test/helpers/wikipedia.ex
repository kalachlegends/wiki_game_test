defmodule WikiGameTest.Wikipedia do
  require Logger

  defp host_url(), do: "https://en.wikipedia.org/"

  def get(url, params \\ %{}, url_full \\ nil) do
    with {:ok, %{status_code: 200} = item} <-
           HTTPoison.get(
             "#{url_full || host_url()}#{url}",
             [],
             params: params
           ) do
      {:ok, item}
    else
      {:ok, %{status_code: 404}} ->
        {:error, :not_found}

      {:ok, %{status_code: 301, headers: headers}} ->
        {_, location} = Enum.find(headers, fn head -> head |> elem(0) == "Location" end)

        get(url, params, location)

      any ->
        IO.inspect(any)
        Logger.error("ERROR FROM GITHUPHELPER url: #{url}")
        any
    end
  end
end
