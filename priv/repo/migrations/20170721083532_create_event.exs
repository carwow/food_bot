defmodule FoodBot.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :date, :utc_datetime
      add :location, :string

      timestamps()
    end

  end
end
