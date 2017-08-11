defmodule FoodBot.SlackBotTest do
  use ExUnit.Case
  doctest FoodBot.SlackBot

  alias FoodBot.{SlackBot, Repo, Event, FoodSource}


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    _japaneseCanteen = Repo.insert! %FoodSource{name: "JapaneseCanteen"}

    sushiPlace = Repo.insert! %FoodSource{
      name: "SushiPlace",
      url: "http://www.youmesushi.com/"
    }

    misterLasagna = Repo.insert! %FoodSource{
      name: "MisterLasagna",
      url: "http://misterlasagna.co.uk/our-menu#main-lasagna-dishes"
    }

    techLunch = Repo.insert! %Event{
      name: "Tech Lunch",
      food_sources: [sushiPlace, misterLasagna]
    }

    [techLunch: techLunch]
  end

  test "list available commands on unknown command" do
    assert SlackBot.handle_command("unknown") == {
      "Available commands are `join_event` and `current_event`", %{}
    }
  end

  test "join_event command: adds event to state", context do
    assert SlackBot.handle_command("join_event", "Tech Lunch") == {
      """
      You joined event "Tech Lunch". You can order from:
       - SushiPlace: http://www.youmesushi.com/
       - MisterLasagna: http://misterlasagna.co.uk/our-menu#main-lasagna-dishes
      """, %{event: context[:techLunch]}
    }
  end

  test "join_event command: event not found" do
    assert SlackBot.handle_command("join_event", "Data Lunch") == {
      """
      Sorry, I can't find event "Data Lunch". Is it one of these?
       - Tech Lunch
      """,
      %{}
    }
  end

  test "join_event command: no event name" do
    assert SlackBot.handle_command("join_event") == {
      """
      Sorry, you didn't provide an event name. Is it one of these?
       - Design Lunch
       - Tech Lunch
      """,
      %{}
    }
  end
end
