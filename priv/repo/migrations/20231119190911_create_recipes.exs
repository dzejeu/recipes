defmodule Recipes.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :prep_time, :integer
      add :cuisine, :string

      timestamps(type: :utc_datetime)
    end
  end
end
