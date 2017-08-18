defmodule FoodBot.JoinEventCommand do
  alias FoodBot.{Repo, Event}
  import FoodBot.CommandHelpers
  import Ecto.Query

  def name, do: "join_event"

  def execute(nil, state) do
    {
      """
      Sorry, you didn't provide an event name. Is it one of these?
      #{latest_events_text()}
      """,
      state
    }
  end
  def execute(name, state) do
    Event
    |> preload(:food_sources)
    |> where(name: ^name)
    |> limit(1)
    |> Repo.one
    |> execute_with_event(name, state)
  end

  defp execute_with_event(nil, name, state) do
    {
      """
      Sorry, I can't find event "#{name}". Is it one of these?
      #{latest_events_text()}
      """,
      state
    }
  end
  defp execute_with_event(event, name, state) do
    {
      """
      You joined event "#{name}". You can order from:
      #{food_sources_text(event)}
      """,
      Map.put(state, :event, event)
    }
  end

  defp food_sources_text(event) do
    event.food_sources
    |> Enum.map(&(" - #{&1.name}: #{&1.url}"))
    |> Enum.join("\n")
  end
end
