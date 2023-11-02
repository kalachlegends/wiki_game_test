defmodule WikiGameTestWeb.HomeLive do
  use Phoenix.LiveView
  alias WikiGameTestWeb.FormComponent

  def render(assigns) do
    ~H"""
    <div class="tw-flex tw-items-center tw-gap-2 tw-flex-col">
 
      <.live_component module={FormComponent} id="hero" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("validate", params, socket) do
    {:noreply, socket}
  end

  def handle_event("wiki_path_get", params, socket) do
    {:noreply, socket}
  end
end
