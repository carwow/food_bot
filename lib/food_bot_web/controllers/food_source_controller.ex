defmodule FoodBotWeb.FoodSourceController do
  use FoodBot.Web, :controller

  alias FoodBot.FoodSource

  def index(conn, _params) do
    food_sources = Repo.all(FoodSource)
    render(conn, "index.html", food_sources: food_sources)
  end

  def new(conn, _params) do
    changeset = FoodSource.changeset(%FoodSource{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"food_source" => food_source_params}) do
    changeset = FoodSource.changeset(%FoodSource{}, food_source_params)

    case Repo.insert(changeset) do
      {:ok, _food_source} ->
        conn
        |> put_flash(:info, "Food source created successfully.")
        |> redirect(to: food_source_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    food_source = Repo.get!(FoodSource, id)
    render(conn, "show.html", food_source: food_source)
  end

  def edit(conn, %{"id" => id}) do
    food_source = Repo.get!(FoodSource, id)
    changeset = FoodSource.changeset(food_source)
    render(conn, "edit.html", food_source: food_source, changeset: changeset)
  end

  def update(conn, %{"id" => id, "food_source" => food_source_params}) do
    food_source = Repo.get!(FoodSource, id)
    changeset = FoodSource.changeset(food_source, food_source_params)

    case Repo.update(changeset) do
      {:ok, food_source} ->
        conn
        |> put_flash(:info, "Food source updated successfully.")
        |> redirect(to: food_source_path(conn, :show, food_source))
      {:error, changeset} ->
        render(conn, "edit.html", food_source: food_source, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    food_source = Repo.get!(FoodSource, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(food_source)

    conn
    |> put_flash(:info, "Food source deleted successfully.")
    |> redirect(to: food_source_path(conn, :index))
  end
end
