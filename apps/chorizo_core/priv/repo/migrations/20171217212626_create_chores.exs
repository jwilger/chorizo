defmodule ChorizoCore.Repositories.Repo.Migrations.CreateChores do
  use Ecto.Migration

  def change do
    create table(:chores) do
      add :name, :string, null: false
      timestamps()
    end

    create unique_index(:chores, [:name])
  end
end
