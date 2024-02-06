defmodule Recipes.Repo.Migrations.RecipesAddMealTag do
  use Ecto.Migration

  def change do
    alter table("recipes") do
      add :meal, :string
    end
  end
end
