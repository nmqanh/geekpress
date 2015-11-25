defmodule MebeWeb.PageController do
  use MebeWeb.Web, :controller

  alias MebeEngine.DB
  import MebeWeb.ControllerUtils, only: [render_posts: 4, insert_config: 1]

  @posts_per_page Application.get_env(:mebe_web, :posts_per_page)

  def index(conn, params) do
    conn
    |> render_page(
      :index,
      [],
      fn first, last -> DB.get_reg_posts(first, last) end,
      DB.get_count(:all),
      "index.html",
      params
      )
  end

  def tag(conn, params) do
    %{"tag" => tag} = params

    conn
    |> assign(:tag, tag)
    |> render_page(
      :tag,
      [tag],
      fn first, last -> DB.get_tag_posts(tag, first, last) end,
      DB.get_count(tag),
      "tag.html",
      params
      )
  end

  def year(conn, params) do
    %{"year" => year} = params

    case Integer.parse year do
      {year, _} ->
        conn
        |> assign(:year, year)
        |> render_page(
          :year,
          [year],
          fn first, last -> DB.get_year_posts(year, first, last) end,
          DB.get_count(year),
          "year.html",
          params
          )

      _ ->
        render_404 conn
    end
  end

  def month(conn, params) do
    %{"year" => year, "month" => month} = params

    case {
      Integer.parse(year),
      Integer.parse(month)
    } do
      {{year, _}, {month, _}} ->
        conn
        |> assign(:year, year)
        |> assign(:month, month)
        |> render_page(
          :month,
          [year, month],
          fn first, last -> DB.get_month_posts(year, month, first, last) end,
          DB.get_count({year, month}),
          "month.html",
          params
          )

      _ ->
        render_404 conn
    end
  end

  def page(conn, %{"slug" => slug}) do
    case DB.get_page slug do
      nil ->
        render_404 conn

      page ->
        conn
        |> insert_config
        |> assign(:page_type, :page)
        |> assign(:page, page)
        |> render("page.html")
    end
  end






  def post(conn, %{"year" => year, "month" => month, "day" => day, "slug" => slug}) do
    case {
      Integer.parse(year),
      Integer.parse(month),
      Integer.parse(day)
    } do
      {{y_int, _}, {m_int, _}, {d_int, _}} ->
        case DB.get_post y_int, m_int, d_int, slug do
          nil ->
            render_404 conn

          post ->
            conn
            |> insert_config
            |> assign(:post, post)
            |> assign(:page_type, :post)
            |> render("post.html")
        end

      _ ->
        render_404 conn
    end
  end

  # Render a list page (a list of posts) or 404 if no posts could be found.
  # The postgetter should be an anonymous function which returns a list of
  # posts when called, or an empty list if none are found. The function gets
  # the first and last post to display as integer arguments.
  defp render_page(conn, page_type, page_args, postgetter, total_count, template, params) do
    page = get_page params
    {first, last} = calculate_ranges page

    case postgetter.(first, last) do
      [] ->
        render_404 conn

      posts ->
        conn
        |> assign(:total_count, total_count)
        |> assign(:current_page, page)
        |> assign(:page_type, page_type)
        |> assign(:page_args, page_args)
        |> render_posts(posts, template, params)
    end
  end

  defp get_page(params) do
    case params do
      %{"page" => page} ->
        {page_int, ""} = Integer.parse page
        page_int

      _ -> 1
    end
  end

  defp calculate_ranges(page) do
    {
      (page - 1) * @posts_per_page,
      @posts_per_page
    }
  end

  defp render_404(conn) do
    conn
    |> assign(:page_type, :not_found)
    |> insert_config
    |> put_status(:not_found)
    |> render(MebeWeb.ErrorView, :"404")
  end
end
