defmodule CodeFishbowl.Router do
  use CodeFishbowl.Web, :router

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

  scope "/", CodeFishbowl do
    pipe_through :browser

    get "/", BowlController, :index

    scope "/bowls" do
      post "/", BowlController, :new
      get "/:bowl", BowlController, :show
    end
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", CodeFishbowl do
  #   pipe_through :api
  # end
end
