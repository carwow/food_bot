defmodule FoodBotWeb.OrderController do
  use FoodBot.Web, :controller

  alias FoodBot.{Event, Order}

  def index(conn, _params) do
    orders = Order
              |> Repo.all
              |> Repo.preload([:event, :food_source])

    render(conn, "index.html", orders: orders)
  end

  def new(conn, %{"event_id" => event_id}) do
    changeset = Order.changeset(%Order{})
    events = fetch_all_events

    event = Repo.get(Event, event_id) |> Repo.preload(:food_sources)

    render(conn, "new.html", changeset: changeset, events: events, event: event)
  end

  def new(conn, _params) do
    changeset = Order.changeset(%Order{})
    events = fetch_all_events
    event = Enum.at(events, 0)

    render(conn, "new.html", changeset: changeset, events: events, event: event)
  end

  def create(conn, %{"order" => order_params}) do
    changeset = Order.changeset(%Order{}, order_params)

    case Repo.insert(changeset) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :index))
      {:error, changeset} ->
        event = Repo.get(Event, order_params["event_id"]) |> Repo.preload(:food_sources)
        render(conn, "new.html", changeset: changeset, events: fetch_all_events, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Order
              |> Repo.get!(id)
              |> Repo.preload([:event, :food_source])

    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id, "event_id" => event_id}) do
    order = Order
              |> Repo.get!(id)
              |> Repo.preload([event: :food_sources])
    event = Repo.get(Event, event_id) |> Repo.preload(:food_sources)
    changeset = Order.changeset(order)
    render(conn, "edit.html", order: order, changeset: changeset, events: fetch_all_events, event: event)
  end

  def edit(conn, %{"id" => id}) do
    order = Order
              |> Repo.get!(id)
              |> Repo.preload([event: :food_sources])
    changeset = Order.changeset(order)
    render(conn, "edit.html", order: order, changeset: changeset, events: fetch_all_events, event: order.event)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Order
              |> Repo.get!(id)
              |> Repo.preload([:event, :food_source])
    changeset = Order.changeset(order, order_params)

    case Repo.update(changeset) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: order_path(conn, :show, order))
      {:error, changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  defp fetch_all_events do
    Event
      |> Repo.all
      |> Repo.preload(:food_sources)
  end

  defp fetch_food_sources(event) do
    event.food_sources
  end
end
