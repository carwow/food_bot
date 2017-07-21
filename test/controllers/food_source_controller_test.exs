defmodule FoodBot.FoodSourceControllerTest do
  use FoodBot.ConnCase

  alias FoodBot.FoodSource
  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, food_source_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing food sources"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, food_source_path(conn, :new)
    assert html_response(conn, 200) =~ "New food source"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, food_source_path(conn, :create), food_source: @valid_attrs
    assert redirected_to(conn) == food_source_path(conn, :index)
    assert Repo.get_by(FoodSource, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, food_source_path(conn, :create), food_source: @invalid_attrs
    assert html_response(conn, 200) =~ "New food source"
  end

  test "shows chosen resource", %{conn: conn} do
    food_source = Repo.insert! %FoodSource{}
    conn = get conn, food_source_path(conn, :show, food_source)
    assert html_response(conn, 200) =~ "Show food source"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, food_source_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    food_source = Repo.insert! %FoodSource{}
    conn = get conn, food_source_path(conn, :edit, food_source)
    assert html_response(conn, 200) =~ "Edit food source"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    food_source = Repo.insert! %FoodSource{}
    conn = put conn, food_source_path(conn, :update, food_source), food_source: @valid_attrs
    assert redirected_to(conn) == food_source_path(conn, :show, food_source)
    assert Repo.get_by(FoodSource, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    food_source = Repo.insert! %FoodSource{}
    conn = put conn, food_source_path(conn, :update, food_source), food_source: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit food source"
  end

  test "deletes chosen resource", %{conn: conn} do
    food_source = Repo.insert! %FoodSource{}
    conn = delete conn, food_source_path(conn, :delete, food_source)
    assert redirected_to(conn) == food_source_path(conn, :index)
    refute Repo.get(FoodSource, food_source.id)
  end
end
