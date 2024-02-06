defmodule Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :name, :string
    field :prep_time, :integer
    field :cuisine, :string
    field :meal, :string
    field :digestion, :integer
    field :ingredients_complexity, :integer
    field :nearby_shop_only, :boolean
    field :is_vegetarian, :boolean
    field :prep_complexity, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :prep_time, :cuisine])
    |> validate_required([:name, :prep_time, :cuisine])
  end
end
