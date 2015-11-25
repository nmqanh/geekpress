defmodule MebeEngine.Parser do
  @moduledoc """
  This module contains the parser, which parses page data and returns the contents in the correct format.
  """

  alias MebeEngine.Models.PageData
  alias MebeEngine.Models.Page
  alias MebeEngine.Models.Post

  @blog_authors Application.get_env(:mebe_web, :blog_authors)

  def parse(pagedata, filename) do
    split_headers(pagedata)
    |> parse_raw(%PageData{filename: filename})
    |> render_content
    |> format
  end

  def split_headers(pagedata) do
    String.split pagedata, ~R/---\r?\n/, trim: true
  end

  def split_lines(pagedata) do
    String.split pagedata, ~R/\r?\n/
  end

  def split_lines(pagedata, :is_trim) do
    String.split pagedata, ~R/\r?\n/, trim: true
  end

  def split_header(header) do
    String.split header, ~R{:}, trim: true
  end

  def parse_raw(dataparts, pagedata \\ %PageData{}, mode \\ :headers)

  def parse_raw([headers | content], pagedata, :headers) do
    parse_raw(content, %{pagedata | headers: parse_headers(%{}, split_lines(headers, :is_trim))}, :content)
  end

  def parse_raw(content, pagedata, :content) when is_list(content) do
    %{pagedata | content: Enum.join(content, "\n")}
  end

  def parse_headers(pageheaders, [header | rest]) do
    [key, val] = split_header(header)
    key = String.strip(key) |> String.to_atom
    val = String.strip(val)
    parse_headers Dict.put(pageheaders, key, val), rest
  end

  def parse_headers(pageheaders, []) do
    pageheaders
  end

  def render_content(pagedata) do
    %{pagedata | content: Earmark.to_html pagedata.content}
  end

  def format(%PageData{
    filename: filename,
    headers: headers,
    content: content
    }) do
    case Regex.run(~R/^(?:(\d{4})-(\d{2})-(\d{2})(?:-(\d{2}))?-)?(.*?).md$/iu, filename) do
      [_, "", "", "", "", slug] ->
        %Page{
          slug: slug,
          title: headers[:title],
          content: content,
          feature_image: headers[:image] || nil,
          author: default_author_if_not_found(headers)
        }

      [_, year, month, day, order, slug] ->

        order = format_order order

        split_content = String.split content, ~R/<!--\s*SPLIT\s*-->/u

        %Post{
          slug: slug,
          title: headers[:title],
          date: date_to_int_tuple({year, month, day}),
          tags: parse_tags(headers[:tags]),
          author: default_author_if_not_found(headers),
          feature_image: headers[:image] || nil,
          content: content,
          short_content: hd(split_content),
          order: order,
          has_more: (Enum.count(split_content) > 1)
        }
    end
  end

  defp default_author_if_not_found(headers) do
    [default | _] = Dict.keys(@blog_authors)
    if Dict.has_key?(@blog_authors, String.to_atom(headers[:author] || "")), do: headers[:author], else: default
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
