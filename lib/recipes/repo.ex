defmodule Recipes.Repo do
  use Ecto.Repo,
    otp_app: :recipes,
    adapter: Ecto.Adapters.SQLite3
end
