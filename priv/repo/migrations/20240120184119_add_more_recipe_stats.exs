defmodule Recipes.Repo.Migrations.AddMoreRecipeStats do
  use Ecto.Migration

  def change do
    alter table("recipes") do
      add :digestion, :integer
      add :ingredients_complexity, :integer
      add :nearby_shop_only, :boolean
      add :is_vegetarian, :boolean
      add :prep_complexity, :integer
    end
  end
end
