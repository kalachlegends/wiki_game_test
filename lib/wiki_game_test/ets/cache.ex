defmodule WikiGameTest.Ets.Cache do
  use GenServer
  @table_name :cache_links
  def insert(page, list_pages, is_have_link_adolf) do
    result = {
      page,
      list_pages,
      is_have_link_adolf
    }

    :ets.insert_new(
      @table_name,
      result
    )

    result
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
