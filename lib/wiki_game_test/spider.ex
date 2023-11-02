defmodule WikiGameTest.Spider do
  use GenServer
  require Logger

  def start_link(attrs) do
    GenServer.start_link(__MODULE__, attrs)
  end

  @impl true
  def init(attrs) do
    # from_pages = attrs[:from_pages] || []

    # GenServer.cast(
    #   self(),
    #   {:recursive, attrs[:page], from_pages, attrs[:original_page] || attrs[:page]}
    # )

    {:ok, attrs}
  end

  @impl true
  def handle_call({:recursive, page, from_pages, original_page}, _from, state) do
    {:ok, {_, list_to_gitler_lvl_0}} = WikiGameTest.Ets.Cache.get("lvl_to_gitler0")
    adolf_gitler = WikiGameTest.Config.Main.get_adolf_gilter_link()

    cond do
      page in list_to_gitler_lvl_0 ->
        GenServer.call(
          self(),
          {:recursive, adolf_gitler, [page | from_pages], original_page},
          1_000_000
        )

      # IO.inspect(list_to_gitler_lvl_0, label: "from_pages")

      page != adolf_gitler ->
        # {:ok, list_filter} = WikiGameTest.Ets.Cache.push_filter_list_without_gitler(page)

        with {:ok, links} <-
               WikiGameTest.Scrapper.get_links_from_page_link(page) do
          Enum.each(links, fn x ->
            GenServer.call(
              self(),
              {:recursive, x, [page | from_pages], original_page},
              1_000_000
            )
          end)

          {:noreply, state, state}
        else
          _ -> {:noreply, state, state}
        end

      true ->
        IO.inspect(from_pages, label: "from_pages")
        {:reply, state, state}
    end
  end

  @impl true
  def handle_call({:find_gitler, from_pages}, _from, state) do
    IO.inspect(from_pages, label: "from_pages")
    {:stop, from_pages, state}
  end

  def test do
    {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/dog", first_init: true})

    pid |> IO.inspect(label: "lib/wiki_game_test/spider.ex:76")
    GenServer.call(pid, {:recursive, "/wiki/Dog", [], "/wiki/Dog"}, 1_000_000)

    #  {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/Mokshas", first_init: true})
    # {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/JS", first_init: true})
    # WikiGameTest.Ets.History.get("wiki/Mokshas")
    # GenServer.call(pid,:get_state)
    # {:ok, {key, list}}= WikiGameTest.Ets.History.get("wiki/Cellular_automatonwiki/Kazakhstan")
    # length(list)
  end
end
