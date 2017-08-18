defmodule FoodBot.BotCase do
  use ExUnit.CaseTemplate

  alias FoodBot.{Repo, Event, FoodSource}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert! %FoodSource{name: "Japanese Canteen"}

    sushiPlace = Repo.insert! %FoodSource{
      name: "Sushi Place",
      url: "http://www.youmesushi.com/"
    }

    misterLasagna = Repo.insert! %FoodSource{
      name: "Mister Lasagna",
      url: "http://misterlasagna.co.uk/our-menu#main-lasagna-dishes"
    }

    techLunch = Repo.insert! %Event{
      name: "Tech Lunch",
      food_sources: [sushiPlace, misterLasagna]
    }

    Repo.insert! %Event{
      name: "Design Lunch",
      food_sources: [misterLasagna]
    }

    [techLunch: techLunch]
  end
end
