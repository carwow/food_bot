defmodule FoodBot.Repo.Migrations.CreateFoodSourcesEvents do
  use Ecto.Migration

  def change do
    create table(:food_sources_events) do
      add :food_source_id, references(:food_sources, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end
    create index(:food_sources_events, [:food_source_id])
    create index(:food_sources_events, [:event_id])

  end
end
