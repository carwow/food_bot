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
    event = Event
            |> preload(:food_sources)
            |> where(name: ^name)
            |> limit(1)
            |> Repo.one

    case event do
      nil ->
        {
          """
          Sorry, I can't find event "#{name}". Is it one of these?
          #{latest_events_text()}
          """,
          state
        }

      event ->
        food_sources_text = event.food_sources
                            |> Enum.map(&(" - #{&1.name}: #{&1.url}"))
                            |> Enum.join("\n")

        {
          """
          You joined event "#{name}". You can order from:
          #{food_sources_text}
          """,
          Map.put(state, :event, event)
        }
    end
  end
end
