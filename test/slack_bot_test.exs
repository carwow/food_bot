defmodule FoodBot.SlackBotTest do
  use ExUnit.Case
  doctest FoodBot.SlackBot

  alias FoodBot.{SlackBot, Repo, Event}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "list available commands on unknown command" do
    assert SlackBot.handle_command("unknown") == {
      "Available commands are `join_event` and `current_event`", %{}
    }
  end

  test "join_event command: adds event to state" do
    event = Repo.insert! %Event{name: "TechLunch"}

    assert SlackBot.handle_command("join_event", ["TechLunch"]) == {
      "You joined event: TechLunch", %{current_event: event}
    }
  end

  test "join_event command: event not found" do
    assert SlackBot.handle_command("join_event", ["TechLunch"]) == {
      "Sorry. Can't find event: TechLunch", %{}
    }
  end

  test "join_event command: no event name" do
    assert SlackBot.handle_command("join_event", []) == {
      "The format is `join_event NAME`", %{}
    }
  end

  def join_tech_lunch_event do
    Repo.insert! %Event{name: "TechLunch"}
    {_, state} = SlackBot.handle_command("join_event", ["TechLunch"])
    state
  end

  test "current_event command: event in state" do
    state = join_tech_lunch_event()

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
