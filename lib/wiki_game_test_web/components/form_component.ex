defmodule WikiGameTestWeb.FormComponent do
  use Phoenix.LiveComponent
  alias WikiGameTestWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-change="validate" phx-submit="wiki_path_get">
        <CoreComponents.input value={@form["wiki_path"]} name="wiki_path" label="Wiki link!" />
        <CoreComponents.button>Save</CoreComponents.button>
      </.form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :form, %{"wiki_path" => ""}) |> assign(:path_result, "")}
  end
end
