defmodule FoodBot.SlackBotTest do
  use FoodBot.BotCase
  doctest FoodBot.SlackBot

  alias FoodBot.SlackBot

  test "list available commands on unknown command" do
    assert SlackBot.handle_command("unknown") == {
      "Available commands are `join_event` and `current_event`", %{}
    }
  end

  test "order command: no event joined" do
    assert SlackBot.handle_command("order", "Regular Funghi Lasagna") == {
      """
      Sorry, you need to join an event first. Is it one of these?
       - Design Lunch
       - Tech Lunch
      """,
      %{}
    }
  end

  test "order command: no order" do
    assert SlackBot.handle_command("order") == {
      "Sorry, you didn't provide an order.", %{}
    }
  end

  test "order command: single food source" do
    {_, state} = SlackBot.handle_command("join_event", "Design Lunch")

    state = Map.put state, :user, %{name: "pedro"}

    assert SlackBot.handle_command("order", "Regular Funghi Lasagna", state) == {
      "Your order has been taken. Thank you.", state
    }
  end
end
