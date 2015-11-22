defmodule MebeEngine.Parser do
  @moduledoc """
  This module contains the parser, which parses page data and returns the contents in the correct format.
  """

  alias MebeEngine.Models.PageData
  alias MebeEngine.Models.Page
  alias MebeEngine.Models.Post

  def parse(pagedata, filename) do
    split_lines(pagedata)
    |> parse_raw(%PageData{filename: filename})
    |> render_content
    |> format
  end

  def split_lines(pagedata) do
    String.split pagedata, ~R/\r?\n/
  end


  def parse_raw(datalines, pagedata \\ %PageData{}, mode \\ :title)

  def parse_raw([title | rest], pagedata, :title) do
    parse_raw rest, %{pagedata | title: title}, :headers
  end

  def parse_raw(["" | rest], pagedata, :headers) do
    # Reverse the headers so they appear in the that they do in the file
    parse_raw rest, %{pagedata | headers: Enum.reverse(pagedata.headers)}, :content
  end

  def parse_raw([header | rest], pagedata, :headers) do
    headers = [header | pagedata.headers]
    parse_raw rest, %{pagedata | headers: headers}, :headers
  end

  def parse_raw(content, pagedata, :content) when is_list(content) do
    %{pagedata | content: Enum.join(content, "\n")}
  end



  def render_content(pagedata) do
    %{pagedata | content: Earmark.to_html pagedata.content}
  end



  def format(%PageData{
    filename: filename,
    title: title,
    headers: headers,
    content: content
    }) do

    case Regex.run(~R/^(?:(\d{4})-(\d{2})-(\d{2})(?:-(\d{2}))?-)?(.*?).md$/iu, filename) do
      [_, "", "", "", "", slug] ->
        %Page{
          slug: slug,
          title: title,
          content: content
        }

      [_, year, month, day, order, slug] ->
        [tags | _] = headers

        order = format_order order

        split_content = String.split content, ~R/<!--\s*SPLIT\s*-->/u

        %Post{
          slug: slug,
          title: title,
          date: date_to_int_tuple({year, month, day}),
          tags: parse_tags(tags),
          content: content,
          short_content: hd(split_content),
          order: order,
          has_more: (Enum.count(split_content) > 1)
        }
    end
  end


  defp parse_tags(tagline) do
    String.split tagline, ~R/,\s*/iu
  end

  defp date_to_int_tuple({year, month, day}) do
    {
      str_to_int(year),
      str_to_int(month),
      str_to_int(day)
    }
  end

  defp str_to_int(str) do
    {int, _} = String.lstrip(str, ?0)
    |> Integer.parse

    int
  end

  defp format_order(""), do: 0
  defp format_order(order), do: str_to_int order
end