defmodule FoodBot.OrderCommandTest do
  use FoodBot.BotCase
  doctest FoodBot.OrderCommand

  alias FoodBot.{OrderCommand, JoinEventCommand}

  test "no event joined" do
    assert OrderCommand.execute("Regular Funghi Lasagna") == {
      """
      Sorry, you need to join an event first. Is it one of these?
       - Design Lunch
       - Tech Lunch
      """,
      %{}
    }
  end

  test "no order" do
    assert OrderCommand.execute(nil) == {
      "Sorry, you didn't provide an order.", %{}
    }
  end

  test "single food source" do
    {_, state} = JoinEventCommand.execute("Design Lunch")

    state = Map.put state, :user, %{name: "pedro"}

    assert OrderCommand.execute("Regular Funghi Lasagna", state) == {
      "Your order has been taken. Thank you.", state
    }
  end
end
