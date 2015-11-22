defmodule MebeWeb.ErrorView do
  use MebeWeb.Web, :view

  @absolute_url Application.get_env(:mebe_web, :absolute_url)

  def render("404.html", %{conn: conn}) do
    render "not_found.html", %{conn: conn}
  end

  def render("500.html", _assigns) do
    "HTTP/1.1 500 Internal Server Error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end

  @doc """
  Get the home page URL of the site.
  """
  def home_url(), do: @absolute_url
end
