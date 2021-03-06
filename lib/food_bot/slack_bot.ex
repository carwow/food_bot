defmodule FoodBot.SlackBot do
  use Slack

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
                       |> find_command
                       |> handle_command(
                         Enum.at(rest, 0),
                         state[message.user] || %{user: slack.users[message.user]}
                       )

    send_message(reply, message.channel, slack)

    {:ok, Map.put(state, message.user, new_state)}
  end
  def handle_event(_, _, state), do: {:ok, state}

  @commands %{
    join_event: FoodBot.JoinEventCommand,
    order: FoodBot.OrderCommand,
  }

  def find_command(cmd) do
    @commands[String.to_atom(cmd)] || FoodBot.NotFoundCommand
  end

  def handle_command(cmd, rest \\ nil, state \\ %{}) do
    cmd.execute(rest, state)
  end
end
