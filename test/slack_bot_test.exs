defmodule FoodBot.SlackBotTest do
  use FoodBot.BotCase
  doctest FoodBot.SlackBot

  alias FoodBot.SlackBot

  test "list available commands on unknown command" do
    assert SlackBot.handle_command("unknown") == {
      "Available commands are `join_event` and `current_event`", %{}
    }
  end
end
