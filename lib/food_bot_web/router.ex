defmodule FoodBotWeb.Router do
  use FoodBot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FoodBotWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/food_sources", FoodSourceController
    resources "/events", EventController
    resources "/orders", OrderController
  end

  # Other scopes may use custom stacks.
  # scope "/api", FoodBot do
  #   pipe_through :api
  # end
end
