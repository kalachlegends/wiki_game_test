defmodule WikiGameTestWeb.FormComponent do
  use Phoenix.LiveComponent
  alias WikiGameTestWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-4xl font-extrabold dark:text-white">
        Wiki game! find gitler from wiki article
      </h1>
      <h2 class="text-2xl  dark:text-white">
        Support only EN version wiki!
      </h2>
      <.form
        class=" flex w-full flex-col gap-3"
        for={@form}
        phx-change="validate"
        phx-submit="wiki_path_get"
      >
        <CoreComponents.input
          value={@form["wiki_path"]}
          name="wiki_path"
          errors={@errors}
          label="Wiki link!"
        />

        <CoreComponents.button>Get link adolf</CoreComponents.button>
      </.form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :form, %{"wiki_path" => ""})}
  end
end
