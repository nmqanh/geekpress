defmodule MebeWeb.FeedController do
  use MebeWeb.Web, :controller

  alias MebeEngine.DB
  import MebeWeb.ControllerUtils, only: [render_posts: 4]

  plug :put_resp_content_type, "application/rss+xml"
  plug :put_layout_formats, ["xml"]
  plug :put_layout, "feed.xml"

  @posts_in_feed Application.get_env(:mebe_web, :posts_in_feed)

  def index(conn, params) do
    posts = DB.get_reg_posts 0, @posts_in_feed

    conn
    |> render_posts(posts, "postlist.xml", params)
  end

  def tag(conn, params) do
    %{"tag" => tag} = params

    posts = DB.get_tag_posts tag, 0, @posts_in_feed

    conn
    |> assign(:tag, tag)
    |> render_posts(posts, "postlist.xml", params)
  end
end
