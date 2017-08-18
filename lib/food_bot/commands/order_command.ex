defmodule FoodBot.OrderCommand do
  alias FoodBot.{Repo, Order}
  import FoodBot.CommandHelpers

  def name, do: "join_event"

  def execute(name, state \\ %{})
  def execute(nil, state) do
    { "Sorry, you didn't provide an order.", state }
  end
  def execute(text, state = %{event: event, user: %{name: user_name}}) do
    case Enum.count event.food_sources do
      0 -> raise "TODO"
      1 ->
        {status, _} = Repo.insert %Order{
          event: event,
          food_source: Enum.at(event.food_sources, 0),
          order: text,
          user_name: user_name
        }

        case status do
          :ok -> { "Your order has been taken. Thank you.", state }
          :error -> { "Something went wrong while saving your order. :(", state }
        end

      _ -> raise "TODO"
    end
  end
  def execute(_, state) do
    {
      """
      Sorry, you need to join an event first. Is it one of these?
      #{latest_events_text()}
      """,
      state
    }
  end
end
