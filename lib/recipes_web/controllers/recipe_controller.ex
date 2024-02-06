defmodule RecipesWeb.RecipeController do
  @all_cuisines [
    "polish",
    "mexican",
    "thai",
    "indian",
    "turkish",
    "italian",
    "usa",
    "french",
    "chinese",
    "ukrainian",
    "czech",
    "spanish",
    "japanese"
  ]

  use RecipesWeb, :controller
  import Ecto.Query

  alias Recipes.{Repo, Recipe}

  def index(conn, _params) do
    all_recipes = Repo.all(Recipe)
    random_dinner = all_recipes |> Enum.filter(fn r -> r.meal == "dinner" end) |> Enum.random()

    random_breakfast =
      all_recipes |> Enum.filter(fn r -> r.meal == "breakfast" end) |> Enum.random()

    conn
    |> render(:index,
      recipes: all_recipes,
      random_breakfast: random_breakfast,
      random_dinner: random_dinner
    )
  end

  def new(conn, _params) do
    conn
    |> render(:new, cuisines: @all_cuisines)
  end

  def delete(conn, params) do
    recipe_to_del =
      case params do
        %{"recipe_id" => rid} -> rid
        _ -> nil
      end

    if recipe_to_del == nil do
      conn
      |> put_flash(:error, "Wrong recipe id")
      |> redirect(to: ~p"/recipes")
    else
      from(r in Recipe, where: r.id == ^recipe_to_del) |> Repo.delete_all()

      conn
      |> put_flash(:info, "Recipe removed!")
      |> redirect(to: ~p"/recipes")
    end
  end

  def create(conn, _params) do
    # TODO: validate incoming data with changeset
    new_recipe =
      case conn.body_params do
        %{
          "cuisine" => c,
          "name" => n,
          "prep_time" => p,
          "meal" => m,
          "is_vegetarian" => is_vege,
          "nearby_shop_only" => nearby_shop_only,
          "prep_complexity" => prep_complexity,
          "ingredients_complexity" => ingredients_complexity,
          "digestion" => digestion
        } ->
          %Recipe{
            cuisine: c,
            name: n,
            prep_time: String.to_integer(p),
            meal: m,
            digestion: String.to_integer(digestion),
            is_vegetarian: is_vege == "yes",
            nearby_shop_only: nearby_shop_only == "yes",
            prep_complexity: String.to_integer(prep_complexity),
            ingredients_complexity: String.to_integer(ingredients_complexity)
          }

        _ ->
          nil
      end

    if new_recipe == nil do
      conn
      |> put_flash(:error, "Wrong data provided!")
      |> redirect(to: ~p"/recipes")
    else
      Repo.insert(new_recipe)

      conn
      |> put_flash(:info, "Recipe created successfully!")
      |> redirect(to: ~p"/recipes")
    end
  end

  def find_page(conn, _params) do
    conn |> render(:find, recipes: [], cuisines: @all_cuisines)
  end

  def find(conn, _params) do
    # TODO: validate incoming data with changeset
    query_params =
      case conn.body_params do
        %{
          "cuisine" => c,
          "meal" => m,
          "is_vegetarian" => is_vege,
          "nearby_shop_only" => nearby_shop_only,
          "fancy_ingredients" => fancy_ingredients,
          "easy_digestion" => easy_digestion
        } ->
          %{
            easy_digestion: easy_digestion == "yes",
            fancy_ingredients: fancy_ingredients == "yes",
            nearby_shop_only: nearby_shop_only == "yes",
            is_vege: is_vege == "yes",
            meal: m,
            cuisine: c
          }

        _ ->
          nil
      end

    if query_params == nil do
      conn
      |> put_flash(:error, "Wrong data provided!")
      |> redirect(to: ~p"/recipes")
    end

    matching_recipes =
      Repo.all(Recipe)
      |> Enum.filter(fn r -> query_params.meal == "any" || r.meal == query_params.meal end)
      |> Enum.filter(fn r ->
        query_params.cuisine == "any" || r.cuisine == query_params.cuisine
      end)
      |> Enum.filter(fn r -> query_params.is_vege == false || r.is_vegetarian == true end)
      |> Enum.filter(fn r ->
        query_params.nearby_shop_only == false || r.nearby_shop_only == true
      end)
      |> Enum.filter(fn r -> query_params.easy_digestion == false || r.digestion < 3 end)
      |> Enum.sort_by(fn r -> r.prep_time end)

    conn |> render(:find, recipes: matching_recipes, cuisines: @all_cuisines)
  end
end
