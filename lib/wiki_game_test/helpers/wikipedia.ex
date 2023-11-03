defmodule WikiGameTest.Wikipedia do
  require Logger

  def host_url(), do: "https://en.wikipedia.org/"

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

      {:ok, %{status_code: 301, headers: _headers}} ->
        {:error, "redirect :()"}

      {:error, %HTTPoison.Error{reason: :checkout_timeout, id: nil}} ->
        Logger.error("checkout_timeoutl: #{url}")
        Process.sleep(16_0000)
        get(url, params, url_full)

      any ->
        IO.inspect(any)
        Logger.error("ERROR FROM GITHUPHELPER url: #{url}")
        any
    end
  end
end
