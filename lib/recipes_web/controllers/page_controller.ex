defmodule RecipesWeb.PageController do
  use RecipesWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/recipes")
  end
end
