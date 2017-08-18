defmodule FoodBot.CommandHelpers do
  alias FoodBot.{Repo, Event}
  import Ecto.Query

  def latest_events_text do
    Event
    |> order_by(desc: :inserted_at)
    |> limit(5)
    |> Repo.all
    |> Enum.map(&(" - #{&1.name}"))
    |> Enum.join("\n")
  end
end
