defmodule WikiGameTest.Ets.History do
  use GenServer
  @table_name :history_links
  def insert(page, history) do
    case :ets.lookup(@table_name, page) do
      [_] ->
        :ets.insert(@table_name, {page, history, %{is_find: true}})
        :ets.insert(@table_name, {List.first(history), history, %{is_find: true}})

      [] ->
        :ets.insert(@table_name, {page, nil, %{is_find: false}})
    end
  end

  def get(page) do
    case :ets.lookup(@table_name, page) do
      [] ->
        {:error, :not_found}

      [result] ->
        {:ok, result}
    end
  end

  def start_link(_) do
    :ets.new(
      @table_name,
      [
        :set,
        :public,
        :named_table
      ]
    )

    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {:ok, nil}
  end
end
