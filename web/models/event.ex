defmodule FoodBot.Event do
  use FoodBot.Web, :model

  schema "events" do
    field :name, :string
    field :date, Ecto.DateTime
    field :location, :string

    many_to_many :food_sources, FoodBot.FoodSource, join_through: FoodBot.FoodSourcesEvents

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}, food_sources \\ []) do
    struct
    |> cast(params, [:name, :date, :location])
    |> validate_required([:name, :date, :location])
    |> put_assoc(:food_sources, food_sources)
  end
end
