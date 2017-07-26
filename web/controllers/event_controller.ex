defmodule FoodBot.EventController do
  use FoodBot.Web, :controller

  alias FoodBot.Event
  alias FoodBot.FoodSource

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})
    food_sources = Enum.map(Repo.all(FoodSource), &{&1.name, &1.id})

    conn
      |> assign(:food_sources, food_sources)
      |> render("new.html", changeset: changeset)
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
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
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
end
