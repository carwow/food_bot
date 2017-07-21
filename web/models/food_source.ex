defmodule FoodBot.FoodSource do
  use FoodBot.Web, :model

  schema "food_sources" do
    field :name, :string
    field :url, :string

    many_to_many :events, Event, join_through: FoodSourcesEvents

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url])
    |> validate_required([:name, :url])
  end
end
