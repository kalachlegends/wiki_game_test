defmodule WikiGameTest.Spider do
  use GenServer
  require Logger

  def start_link(attrs) do
    GenServer.start_link(__MODULE__, attrs)
  end

  @impl true
  def init(attrs) do
    if attrs[:first_init] do
      WikiGameTest.Ets.History.insert(attrs[:page], [])
    end

    from_pages = attrs[:from_pages] || []

    GenServer.cast(
      self(),
      {:recursive, attrs[:page], from_pages, attrs[:original_page] || attrs[:page]}
    )

    {:ok, attrs}
  end

  @impl true
  def handle_cast({:recursive, page, from_pages, original_page}, state) do
    case WikiGameTest.Ets.History.get(original_page) do
      {:ok, {_p, _his, %{is_find: true}}} -> GenServer.stop(self())
      _ -> nil
    end

    if page != WikiGameTest.Config.Main.get_adolf_gilter_link() do
      with {:ok, links} <-
             WikiGameTest.get_links_from_page(page) do
        # WikiGameTest.Ets.History.insert(state[:page], page)
        Logger.info("PARSING #{page}")

        Enum.map(links, fn x ->
          GenServer.start_link(
            __MODULE__,
            %{page: x, from_pages: [page | from_pages], original_page: original_page},
            hibernate_after: 10_000
          )
        end)

        {:noreply, state}
      else
        _ -> {:noreply, state}
      end
    else
      IO.inspect(original_page)
      IO.inspect(from_pages)
      IO.inspect(page)
      WikiGameTest.Ets.History.insert(original_page, from_pages)
      GenServer.stop(self())
      {:stop, :normal, state}
    end
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def test do
    # {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/Cattle", first_init: true})
    # GenServer.call(pid,:get_state)
    # {:ok, {key, list}}= WikiGameTest.Ets.History.get("wiki/Kazakhstan")
    # length(list)
  end
end
