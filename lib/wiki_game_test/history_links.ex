defmodule WikiGameTest.HistoryLinks do
  alias WikiGameTest.HistoryLinks
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "history_links" do
    field(:link, :string)
    field(:lvl_to_gitler, :integer)

    timestamps()
  end

  use WikiGameTest.Use.RepoBase, repo: WikiGameTest.Repo
  @doc false
  def changeset(history_links, attrs) do
    history_links
    |> cast(attrs, [:link, :lvl_to_gitler])
    |> validate_required([:link, :lvl_to_gitler])
  end

  def get_by_lvl(from, to) do
    from(history in HistoryLinks, where: history.lvl >= ^from and history.lvl <= ^to)
  end
end
