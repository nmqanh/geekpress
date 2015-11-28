defmodule MebeWeb.Plugs.ForceSSL do
  import Plug.Conn

  @force_ssl Application.get_env(:mebe_web, :force_ssl)

  def init(default), do: default

  def call(conn, _default) when @force_ssl == true do
    if conn.scheme == :http do
      new_path = "https://" <> conn.host <> conn.request_path <> "?" <> conn.query_string
      conn
       |> put_status(301)
       |> Phoenix.Controller.redirect(external: new_path)
       |> halt
    else
      conn
    end
  end

  def call(conn, _default) when @force_ssl == false do
    conn
  end
end

defmodule MebeWeb.Router do
  use Phoenix.Router

  @enable_feeds Application.get_env(:mebe_web, :enable_feeds)

  pipeline :browser do
    plug MebeWeb.RequestStartTimePlug
    plug MebeWeb.Plugs.ForceSSL
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
