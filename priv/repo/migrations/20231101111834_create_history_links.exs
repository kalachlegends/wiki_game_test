defmodule WikiGameTest.Repo.Migrations.CreateHistoryLinks do
  use Ecto.Migration

  def change do
    create table(:history_links) do
      add :link, :string
      add :lvl_to_gitler, :integer

      timestamps()
    end
  end
end
