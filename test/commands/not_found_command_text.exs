defmodule FoodBot.NotFoundCommandTest do
  use ExUnit.Case
  doctest FoodBot.NotFoundCommand

  alias FoodBot.NotFoundCommand

  test "list available commands on unknown command" do
    assert NotFoundCommand.execute() == {
      "Available commands are `join_event` and `order`", %{}
    }
  end
end
