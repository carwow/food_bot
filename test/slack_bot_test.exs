defmodule FoodBot.SlackBotTest do
  use FoodBot.BotCase
  doctest FoodBot.SlackBot

  alias FoodBot.SlackBot

  test "finds join_event command" do
    assert SlackBot.find_command("join_event") == FoodBot.JoinEventCommand
  end

  test "finds order command" do
    assert SlackBot.find_command("order") == FoodBot.OrderCommand
  end

  test "default to not found command" do
    assert SlackBot.find_command("...") == FoodBot.NotFoundCommand
  end
end
