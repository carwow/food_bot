defmodule FoodBot.SlackBot do
  use Slack

  alias FoodBot.{Repo, Event, Order}
  import Ecto.Query

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

  def latest_events_text do
    Event
    |> order_by(desc: :inserted_at)
    |> limit(5)
    |> Repo.all
    |> Enum.map(&(" - #{&1.name}"))
    |> Enum.join("\n")
  end

  def handle_command(cmd, rest \\ nil, state \\ %{})
  def handle_command("join_event", nil, state) do
    {
      """
      Sorry, you didn't provide an event name. Is it one of these?
      #{latest_events_text()}
      """,
      state
    }
  end
  def handle_command("join_event", name, state) do
    event = Event
            |> preload(:food_sources)
            |> where(name: ^name)
            |> limit(1)
            |> Repo.one

    case event do
      nil ->
        {
          """
          Sorry, I can't find event "#{name}". Is it one of these?
          #{latest_events_text()}
          """,
          state
        }

      event ->
        food_sources_text = event.food_sources
                            |> Enum.map(&(" - #{&1.name}: #{&1.url}"))
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
