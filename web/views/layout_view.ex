defmodule MebeWeb.LayoutView do
  use MebeWeb.Web, :view

  @default_title Application.get_env(:mebe_web, :blog_name)
  @extra_html Application.get_env(:mebe_web, :extra_html)

  @feeds_enabled Application.get_env(:mebe_web, :enable_feeds)

  @doc """
  Resolve title from the current assigns. Will use the current page's or post's title, if available.
  Otherwise will render default title.
  """
  def title(conn) do
    cond do
      conn.assigns[:post] ->
        conn.assigns[:post].title

      conn.assigns[:page] ->
        conn.assigns[:page].title

      true -> @default_title
    end
  end

  @doc """
  Return the extra HTML defined in the config.
  """
  def extra_html(), do: @extra_html

  if not @feeds_enabled do
    @doc """
    If feeds are not enabled, mock the feed_path functions so that compilation does not crash because
    of missing feed_path.
    """
    def feed_path(_, _), do: nil
    def feed_path(_, _, _), do: nil
  end

  @doc """
  Calculate time taken for request so far.
  """
  def request_time(conn) do
    MebeWeb.RequestStartTimePlug.calculate_time conn
  end

  def safe_round(val) when is_integer(val), do: val
  def safe_round(val), do: Float.round val
end
