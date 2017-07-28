defmodule FoodBot.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_name, :string
      add :order, :string
      add :event_id, references(:events, on_delete: :nothing)
      add :food_source_id, references(:food_sources, on_delete: :nothing)

      timestamps()
    end
    create index(:orders, [:event_id])
    create index(:orders, [:food_source_id])

  end
end
