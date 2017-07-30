defmodule FoodBot.FoodSourcesEvents do
  use FoodBot.Web, :model

  schema "food_sources_events" do
    belongs_to :food_source, FoodBot.FoodSource
    belongs_to :event, FoodBot.Event

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_source_id, :event_id])
    |> validate_required([])
  end
end
