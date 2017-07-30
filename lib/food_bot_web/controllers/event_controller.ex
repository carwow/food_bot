defmodule FoodBotWeb.EventController do
  use FoodBot.Web, :controller

  alias FoodBot.Event
  alias FoodBot.FoodSource

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})

    render(conn, "new.html", food_sources: fetch_all_food_sources, changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    food_sources = Repo.all(from fs in FoodBot.FoodSource, where: fs.id in ^event_params["food_sources_ids"])
    changeset = Event.changeset(%Event{}, event_params, food_sources)

    case Repo.insert(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, food_sources: fetch_all_food_sources)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
      |> Repo.preload(:food_sources)
    changeset = Event.changeset(event)

    render(conn, "edit.html", event: event, changeset: changeset, food_sources: fetch_all_food_sources, selected_food_source_ids: Enum.map(event.food_sources, &(&1.id)))
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Repo.get!(Event, id)
      |> Repo.preload(:food_sources)
    food_sources = Repo.all(from fs in FoodBot.FoodSource, where: fs.id in ^event_params["food_sources_ids"])
    changeset = Event.changeset(event, event_params, food_sources)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset, food_sources: fetch_all_food_sources)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end

  defp fetch_all_food_sources do
    Repo.all(FoodSource)
      |> Enum.map &{&1.name, &1.id}
  end
end
