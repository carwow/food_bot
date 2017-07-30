defmodule FoodBotWeb.PageController do
  use FoodBot.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
