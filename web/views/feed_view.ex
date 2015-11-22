defmodule MebeWeb.FeedView do
  use MebeWeb.Web, :view

  @feeds_full_content Application.get_env(:mebe_web, :feeds_full_content)

  def show_full(), do: @feeds_full_content
end
