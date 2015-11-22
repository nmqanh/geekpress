defmodule MebeWeb.Router do
  use Phoenix.Router

  @enable_feeds Application.get_env(:mebe_web, :enable_feeds)

  pipeline :browser do
    plug MebeWeb.RequestStartTimePlug
    plug :accepts, ["html", "xml"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/", MebeWeb do
    pipe_through :browser

    get "/p/:page", PageController, :index
    get "/", PageController, :index
    if @enable_feeds, do: (get "/feed", FeedController, :index)

    get "/tag/:tag/p/:page", PageController, :tag
    get "/tag/:tag", PageController, :tag
    if @enable_feeds, do: (get "/tag/:tag/feed", FeedController, :tag)

    get "/archive/:year/p/:page", PageController, :year
    get "/archive/:year", PageController, :year
    get "/archive/:year/:month/p/:page", PageController, :month
    get "/archive/:year/:month", PageController, :month

    get "/:year/:month/:day/:slug", PageController, :post
    get "/:slug", PageController, :page
  end
end
