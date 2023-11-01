defmodule WikiGameTest.HistoryLinks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "history_links" do
    field :link, :string
    field :lvl_to_gitler, :integer

    timestamps()
  end

  use WikiGameTest.Use.RepoBase, repo: WikiGameTest.Repo
  @doc false
  def changeset(history_links, attrs) do
    history_links
    |> cast(attrs, [:link, :lvl_to_gitler])
    |> validate_required([:link, :lvl_to_gitler])
  end
end
