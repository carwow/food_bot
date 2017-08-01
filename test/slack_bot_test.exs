defmodule FoodBot.SlackBotTest do
  use ExUnit.Case
  doctest FoodBot.SlackBot

  test "list available commands on unknown command" do
    assert FoodBot.SlackBot.handle_command("unknown") == {
      "Available commands are `join_event` and `current_event`", %{}
    }
  end

  test "join_event command: adds event name to state" do
    assert FoodBot.SlackBot.handle_command("join_event", ["TechLunch"]) == {
      "You joined event: TechLunch", %{current_event: "TechLunch"}
    }
  end

  test "join_event command: no event name" do
    assert FoodBot.SlackBot.handle_command("join_event", []) == {
      "The format is `join_event NAME`", %{}
    }
  end

  test "current_event command: event in state" do
    assert FoodBot.SlackBot.handle_command("current_event", [], %{current_event: "TechLunch"}) == {
      "You are ordering for event: TechLunch", %{current_event: "TechLunch"}
    }
  end

  test "current_event command: no event in state" do
    assert FoodBot.SlackBot.handle_command("current_event") == {
      "You haven't joined an event yet.", %{}
    }
  end
end
