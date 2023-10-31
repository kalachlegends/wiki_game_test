defmodule WikiGameTest.Ets.History do
  use GenServer
  @table_name :history_links
  def insert(page, history_page) do
    case :ets.lookup(@table_name, page) do
      [{_page, history_list}] ->
        :ets.insert(@table_name, {page, [history_page | history_list]})

      [] ->
        :ets.insert_new(@table_name, {page, [history_page]})
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
