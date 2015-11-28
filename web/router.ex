defmodule MebeWeb.Plugs.ForceRedirect do
  import Plug.Conn

  @force_ssl Application.get_env(:mebe_web, :force_ssl)
  @force_accurate_host Application.get_env(:mebe_web, :force_accurate_host)
  @endpoint Application.get_env :mebe_web, MebeWeb.Endpoint

  def init(default), do: default

  def call(conn, _default) do
    accurate_host = if @force_accurate_host && @endpoint[:url][:host] != conn.host, do: @endpoint[:url][:host], else: conn.host
    query_string = if conn.query_string !== "", do: "?" <> conn.query_string, else: ""
    cond do
      @force_ssl == true  && conn.scheme == :http ->
        new_path = "https://" <> accurate_host <> conn.request_path <> query_string
        conn
         |> put_status(301)
         |> Phoenix.Controller.redirect(external: new_path)
         |> halt
      @force_ssl == false && @force_accurate_host == true && accurate_host != conn.host ->
        port = if conn.port == 80 || conn.scheme == :https, do: "", else: ":" <> Integer.to_string(conn.port)
        scheme = if conn.scheme == :http, do: "http://", else: "https://"
        new_path = scheme <> accurate_host <> port <> conn.request_path <> query_string
        conn
         |> put_status(301)
         |> Phoenix.Controller.redirect(external: new_path)
         |> halt

      true ->
        conn
    end
  end
end

defmodule MebeWeb.Router do
  use Phoenix.Router

  @enable_feeds Application.get_env(:mebe_web, :enable_feeds)

  pipeline :browser do
    plug MebeWeb.RequestStartTimePlug
    plug MebeWeb.Plugs.ForceRedirect
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
