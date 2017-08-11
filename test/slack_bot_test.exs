defmodule FoodBot.SlackBotTest do
  use ExUnit.Case
  doctest FoodBot.SlackBot

  alias FoodBot.{SlackBot, Repo, Event, FoodSource}


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    _japaneseCanteen = Repo.insert! %FoodSource{name: "JapaneseCanteen"}
    sushiPlace      = Repo.insert! %FoodSource{name: "SushiPlace"}
    misterLasagna   = Repo.insert! %FoodSource{name: "MisterLasagna"}

    techLunch = Repo.insert! %Event{
      name: "TechLunch",
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
    assert SlackBot.handle_command("join_event", ["TechLunch"]) == {
      """
      You joined event "TechLunch". You can order from:
       - <|SushiPlace>
       - <|MisterLasagna>
      """, %{event: context[:techLunch]}
    }
  end

  test "join_event command: event not found" do
    assert SlackBot.handle_command("join_event", ["DataLunch"]) == {
      "Sorry. Can't find event: DataLunch", %{}
    }
  end

  test "join_event command: no event name" do
    assert SlackBot.handle_command("join_event", []) == {
      "The format is `join_event NAME`", %{}
    }
  end

  test "current_event command: event in state" do
    {_, state} = SlackBot.handle_command("join_event", ["TechLunch"])

    assert SlackBot.handle_command("current_event", [], state) == {
      "You are ordering for event: TechLunch", state
    }
  end

  test "current_event command: no event in state" do
    assert SlackBot.handle_command("current_event") == {
      "You haven't joined an event yet.", %{}
    }
  end
end
