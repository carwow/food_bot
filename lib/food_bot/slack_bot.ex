defmodule FoodBot.SlackBot do
  use Slack

  alias FoodBot.{Repo, Event}
  import Ecto.Query

  def start_link() do
    Slack.Bot.start_link(__MODULE__, %{}, Application.get_env(:food_bot, :slack_bot_token))
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
    event = Event
            |> preload(:food_sources)
            |> where(name: ^name)
            |> limit(1)
            |> Repo.one

    case event do
      nil ->
        {
          "Sorry. Can't find event: #{name}",
          state
        }

      event ->
        food_sources_text = event.food_sources
                            |> Enum.map(&(" - <#{&1.url}|#{&1.name}>"))
                            |> Enum.join("\n")

        {
          """
          You joined event "#{name}". You can order from:
          #{food_sources_text}
          """,
          Map.put(state, :event, event)
        }
    end
  end
  def handle_command("join_event", _, state) do
    {
      "The format is `join_event NAME`",
      state
    }
  end
  def handle_command("current_event", _, state = %{event: event}) do
    {
      "You are ordering for event: " <> event.name,
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
