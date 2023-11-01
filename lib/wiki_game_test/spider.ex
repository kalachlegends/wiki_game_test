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
    {:ok, list_filter} = WikiGameTest.Ets.Cache.push_filter_list_without_gitler(page)

    if page != WikiGameTest.Config.Main.get_adolf_gilter_link() do
      with {:ok, links} <-
             WikiGameTest.get_links_from_page(page) do
        IO.inspect(list_filter |> length)

        Enum.each(links, fn x ->
          if !(x in list_filter) do
            :poolboy.transaction(
              :worker,
              fn pid ->
                IO.inspect(pid)

                # Let's wrap the genserver call in a try - catch block. This allows us to trap any exceptions
                # that might be thrown and return the worker back to poolboy in a clean manner. It also allows
                # the programmer to retrieve the error and potentially fix it.
                try do
                  GenServer.call(pid, {:recursive, x, [page | from_pages], original_page})
                catch
                  e, r ->
                    # IO.inspect("poolboy transaction caught error: #{inspect(e)}, #{inspect(r)}")
                    :ok
                end
              end,
              2000
            )
          end
        end)

        {:reply, state, state}
      else
        _ -> {:reply, state, state}
      end
    else
      WikiGameTest.Ets.History.insert(original_page, from_pages)
      IO.inspect(from_pages)
      IO.inspect(from_pages)

      IO.inspect(from_pages)
      IO.inspect(from_pages)
      IO.inspect(from_pages)
      IO.inspect(from_pages)
      IO.inspect(from_pages)

      {:reply, state, state}
    end
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def test do
    # {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/Eukaryote", first_init: true})
    #   GenServer.call(pid, {:recursive, "wiki/Eukaryote", [], "wiki/Eukaryote"})
    #  {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/Mokshas", first_init: true})
    # {:ok, pid} = GenServer.start_link(WikiGameTest.Spider, %{page: "wiki/JS", first_init: true})
    # WikiGameTest.Ets.History.get("wiki/Mokshas")
    # GenServer.call(pid,:get_state)
    # {:ok, {key, list}}= WikiGameTest.Ets.History.get("wiki/Cellular_automatonwiki/Kazakhstan")
    # length(list)
  end
end
