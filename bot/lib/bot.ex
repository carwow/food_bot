defmodule Bot do
  use Application
  use Slack

  def start(_type, _args) do
    IO.puts "Starting..."
    Slack.Bot.start_link(Bot, %{}, Application.get_env(:bot, :token))
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    [cmd | args] = String.split message.text
    {reply, new_state} = cmd
                       |> String.downcase
                       |> handle_command(args, state[message.user] || %{})
    send_message(reply, message.channel, slack)
    {:ok, Map.put(state, message.user, new_state)}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_command(cmd, args \\ [], state \\ %{})
  def handle_command("join_event", [name], state) do
    {
      "You joined event: " <> name,
      Map.put(state, :current_event, name)
    }
  end
  def handle_command("join_event", _, state) do
    {
      "The format is `join_event NAME`",
      state
    }
  end
  def handle_command("current_event", _, state = %{current_event: current_event}) do
    {
      "You are ordering for event: " <> current_event,
      state
    }
  end
  def handle_command("current_event", _, state) do
    {
      "You haven't joined an event yet.",
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
