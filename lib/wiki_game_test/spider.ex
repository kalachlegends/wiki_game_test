defmodule WikiGameTest.Spider do
  use GenServer

  def start_link(attrs) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(attrs) do
    GenServer.cast(self(), {:recursive, attrs[:page]})
    WikiGameTest.Ets.History.insert(attrs[:page], [])
    {:ok, attrs}
  end

  @impl true
  def handle_cast({:recursive, page}, state) do
    if page != WikiGameTest.Config.Main.get_adolf_gilter_link() do
      with {:ok, links} <-
             WikiGameTest.get_links_from_page(page) do
        WikiGameTest.Ets.History.insert(state[:page], page)
        Enum.map(links, fn x -> GenServer.cast(self(), {:recursive, x}) end)
        {:noreply, state}
      else
        _ -> {:noreply, state}
      end
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def test do
    {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/Kazakhstan"})
    # GenServer.call(pid,:get_state)
    # {:ok, {key, list}}= WikiGameTest.Ets.History.get("wiki/Kazakhstan")
    # length(list)
  end
end
