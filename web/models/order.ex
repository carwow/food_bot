defmodule FoodBot.Order do
  use FoodBot.Web, :model

  schema "orders" do
    field :user_name, :string
    field :order, :string
    belongs_to :event, FoodBot.Event, on_replace: :update
    belongs_to :food_source, FoodBot.FoodSource, on_replace: :update

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_name, :order, :event_id, :food_source_id])
    |> validate_required([:user_name, :order, :event_id, :food_source_id])
    |> add_event(params)
    |> add_food_source(params)
  end

  defp add_event(changeset, params) when params == %{} do
    changeset
  end

  defp add_event(changeset, %{"event_id" => event_id}) do
    put_assoc(changeset, :event, FoodBot.Repo.get(FoodBot.Event, event_id))
  end

  defp add_food_source(changeset, params) when params == %{} do
    changeset
  end

  defp add_food_source(changeset, %{"food_source_id" => food_source_id}) do
    put_assoc(changeset, :food_source, FoodBot.Repo.get(FoodBot.FoodSource, food_source_id))
  end
end
