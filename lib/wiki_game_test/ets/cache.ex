defmodule WikiGameTest.Ets.Cache do
  use GenServer
  @table_name :cache_links

  def start_link(_) do
    :ets.new(
      @table_name,
      [
        :set,
        :public,
        :named_table
      ]
    )

    :ets.insert_new(
      @table_name,
      {"filter_list_without_gitler", []}
    )

    GenServer.start_link(__MODULE__, [])
  end

  def push_filter_list_without_gitler(page) do
    case get("filter_list_without_gitler") do
      {:ok, {_, pages}} ->
        :ets.insert(
          @table_name,
          {"filter_list_without_gitler", [page | pages]}
        )

        {:ok, pages}

      any ->
        any
    end
  end

  def get(id) do
    case :ets.lookup(@table_name, id) do
      [] ->
        {:error, :not_found}

      [result] ->
        {:ok, result}
    end
  end

  def init(_) do
    {:ok, nil}
  end
end
