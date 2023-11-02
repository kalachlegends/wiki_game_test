defmodule WikiGameTest.Scrapper.Starter do
  alias WikiGameTest.HistoryLinks
  alias WikiGameTest.Scrapper
  alias WikiGameTest.Config.Main, as: ConfigMain
  use GenServer

  def start_link(init_args) do
    GenServer.start_link(__MODULE__, [init_args])
  end

  def init(_args) do
    start()
    {:ok, :initial_state}
  end

  def start() do
    # Task.async(fn -> start_lvl_0() end)
    # Task.async(fn -> start_lvl_1() end)

    Task.async(fn ->
      (HistoryLinks.get_all!() || [])
      |> Enum.each(fn x ->
        IO.inspect(x, label: "asx")
        WikiGameTest.Ets.Cache.push_lvl_to_gitler(x.lvl_to_gitler, x.link)
      end)
    end)
  end

  def start_lvl_0() do
    adolf_link = ConfigMain.get_adolf_gilter_link()

    with {:ok, links_from_adolf} <- Scrapper.get_links_from_page_link(adolf_link) do
      links_from_adolf
      |> Enum.each(fn x_link ->
        push_lvl_by_sort(x_link)
      end)
    end
  end

  def start_lvl_1() do
    with {:ok, links} <- Scrapper.get_coutries() do
      links
      |> Enum.each(fn x_link ->
        push_lvl_by_sort(x_link)
      end)
    end
  end

  def push_lvl_by_sort(x_link) do
    adolf_link = ConfigMain.get_adolf_gilter_link()
    word_of_war_link = ConfigMain.get_word_of_war()

    with {:error, _} <- HistoryLinks.get(link: x_link) do
      with {:ok, links} <- Scrapper.get_links_from_page_link(x_link) do
        cond do
          adolf_link in links ->
            WikiGameTest.Ets.Cache.push_lvl_to_gitler(0, x_link)

          word_of_war_link in links ->
            push_lvl(1, x_link)
            WikiGameTest.Ets.Cache.push_lvl_to_gitler(1, x_link)

          true ->
            push_lvl(-1, x_link)
            WikiGameTest.Ets.Cache.push_lvl_to_gitler(-1, x_link)
        end
      end
    end
  end

  def push_lvl(lvl, link) do
    HistoryLinks.update_or_create(%{link: link}, %{link: link, lvl_to_gitler: lvl})
  end
end
