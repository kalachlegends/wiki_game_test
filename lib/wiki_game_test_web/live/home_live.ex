defmodule WikiGameTestWeb.HomeLive do
  use Phoenix.LiveView
  alias WikiGameTestWeb.FormComponent
  alias WikiGameTestWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <CoreComponents.flash_group flash={@flash} />
    <div class="tw-flex tw-items-center tw-gap-2 tw-flex-col">
      <.live_component module={FormComponent} errors={@errors} id="hero" />
      <div :if={@wiki_path_result != ""}>Result: <%= @wiki_path_result %></div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:wiki_path_result, "") |> assign(:errors, [])}
  end

  def handle_event("validate", params, socket) do
    cond do
      String.contains?(params["wiki_path"], WikiGameTest.Wikipedia.host_url()) ->
        {:noreply, socket |> assign(:errors, []) |> assign(:wiki_path_result, "")}

      String.contains?(params["wiki_path"], "http") ->
        {:noreply,
         socket |> assign(:errors, ["This link isn't valid"]) |> assign(:wiki_path_result, "")}

      !Regex.match?(
        ~r/(\/?[^\/\n\s]+\/?[^\/\n\s]+?)+/,
        params["wiki_path"]
      ) ->
        {:noreply,
         socket |> assign(:errors, ["This link isn't valid"]) |> assign(:wiki_path_result, "")}

      true ->
        {:noreply, socket |> assign(:errors, []) |> assign(:wiki_path_result, "")}
    end
  end

  def handle_event("wiki_path_get", params, socket) do
    with {:ok, list_path} <-
           WikiGameTest.Gitler.search_gitler(params["wiki_path"]) do
      {:noreply,
       update(socket, :wiki_path_result, fn _x ->
         list_path |> Enum.reverse() |> Enum.join(" -> ")
       end)
       |> put_flash(:info, "We find Adolf!")}
    else
      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end
end
