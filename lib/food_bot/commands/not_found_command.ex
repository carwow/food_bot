defmodule FoodBot.NotFoundCommand do
  def execute(_ \\ nil, state \\ %{}) do
    { "Available commands are `join_event` and `order`", state }
  end
end
