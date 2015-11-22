defmodule MebeWeb.ControllerUtils do
  use MebeWeb.Web, :controller

  @moduledoc """
  This module contains the common functions for all controllers.
  """

  @blog_name Application.get_env(:mebe_web, :blog_name)
  @blog_author Application.get_env(:mebe_web, :blog_author)
  @absolute_url Application.get_env(:mebe_web, :absolute_url)
  @posts_per_page Application.get_env(:mebe_web, :posts_per_page)
  @disqus_comments Application.get_env(:mebe_web, :disqus_comments)
  @page_commenting Application.get_env(:mebe_web, :page_commenting)
  @disqus_shortname Application.get_env(:mebe_web, :disqus_shortname)
  @feeds_enabled Application.get_env(:mebe_web, :enable_feeds)
  @force_read_more Application.get_env(:mebe_web, :force_read_more)

  @doc """
  Render a list of posts with the given template and params. The posts
  and generic configuration settings are assigned to the connection.
  """
  def render_posts(conn, posts, template, _params) do
    conn
    |> insert_config
    |> assign(:posts, posts)
    |> render(template)
  end

  @doc """
  Insert common config variables to the assigns table for the connection
  """
  def insert_config(conn) do
    conn
    |> assign(:blog_name, @blog_name)
    |> assign(:blog_author, @blog_author)
    |> assign(:absolute_url, @absolute_url)
    |> assign(:posts_per_page, @posts_per_page)
    |> assign(:disqus_comments, @disqus_comments)
    |> assign(:page_commenting, @page_commenting)
    |> assign(:disqus_shortname, @disqus_shortname)
    |> assign(:feeds_enabled, @feeds_enabled)
    |> assign(:force_read_more, @force_read_more)
  end
end
