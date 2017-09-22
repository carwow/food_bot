defmodule FoodBot.JoinEventCommandTest do
  use FoodBot.BotCase
  doctest FoodBot.JoinEventCommand

  alias FoodBot.JoinEventCommand

  test "adds event to state", context do
    assert JoinEventCommand.execute("Tech Lunch") == {
      """
      You joined event "Tech Lunch". You can order from:
       - Sushi Place: http://www.youmesushi.com/
       - Mister Lasagna: http://misterlasagna.co.uk/our-menu#main-lasagna-dishes
      """, %{event: context[:techLunch]}
    }
  end

  test "event not found" do
    assert JoinEventCommand.execute("Data Lunch") == {
      """
      Sorry, I can't find event "Data Lunch". Is it one of these?
       - Design Lunch
       - Tech Lunch
      """,
      %{}
    }
  end

  test "no event name" do
    assert JoinEventCommand.execute(nil) == {
      """
      Sorry, you didn't provide an event name. Is it one of these?
       - Design Lunch
       - Tech Lunch
      """,
      %{}
    }
  end
end
