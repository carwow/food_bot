defmodule FoodBot.SlackBot do
  use Slack

  alias FoodBot.{Repo, Order}
  import FoodBot.CommandHelpers

  def start_link() do
    Slack.Bot.start_link(__MODULE__, %{}, Application.get_env(:food_bot, :slack_bot_token))
  end

  def handle_event(%{user: me}, %{me: %{id: me}}, state), do: {:ok, state}
  def handle_event(%{subtype: "bot_message"}, _, state), do: {:ok, state}
  def handle_event(%{subtype: "message_changed"}, _, state), do: {:ok, state}
  def handle_event(message = %{type: "message"}, slack, state) do
    [cmd | rest] = message.text
                   |> String.trim
                   |> String.split(~r/\s+/, parts: 2)

    {reply, new_state} = cmd
                       |> String.downcase
                       |> handle_command(
                         Enum.at(rest, 0),
                         state[message.user] || %{user: slack.users[message.user]}
                       )

    send_message(reply, message.channel, slack)

    {:ok, Map.put(state, message.user, new_state)}
  end
  def handle_event(_, _, state), do: {:ok, state}


  def handle_command(cmd, rest \\ nil, state \\ %{})

  def handle_command("join_event", name, state) do
    FoodBot.JoinEventCommand.execute(name, state)
  end
  def handle_command("order", nil, state) do
    { "Sorry, you didn't provide an order.", state }
  end
  def handle_command("order", text, state = %{event: event, user: %{name: user_name}}) do
    case Enum.count event.food_sources do
      0 -> raise "TODO"
      1 ->
        {status, _} = Repo.insert %Order{
          event: event,
          food_source: Enum.at(event.food_sources, 0),
          order: text,
          user_name: user_name
        }

        case status do
          :ok -> { "Your order has been taken. Thank you.", state }
          :error -> { "Something went wrong while saving your order. :(", state }
        end

      _ -> raise "TODO"
    end
  end
  def handle_command("order", _, state) do
    {
      """
      Sorry, you need to join an event first. Is it one of these?
      #{latest_events_text()}
      """,
      state
    }
  end
  def handle_command(_, _, state) do
    {
      "Available commands are `join_event` and `current_event`",
      state
    }
  end

end
