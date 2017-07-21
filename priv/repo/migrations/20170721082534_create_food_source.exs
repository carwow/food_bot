defmodule FoodBot.Repo.Migrations.CreateFoodSource do
  use Ecto.Migration

  def change do
    create table(:food_sources) do
      add :name, :string
      add :url, :string

      timestamps()
    end

  end
end
