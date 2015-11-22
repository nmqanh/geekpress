defmodule MebeEngine.Crawler do
  @moduledoc """
  The crawler goes through the specified directory, opening and parsing all the matching files
  inside concurrently.
  """
  require Logger

  alias MebeEngine.Parser

  alias MebeEngine.Models.Page
  alias MebeEngine.Models.Post

  def crawl(path) do
    get_files(path)
    |> Enum.map(fn file -> Task.async MebeEngine.Crawler, :parse, [file] end)
    |> handle_responses
    |> construct_archives
  end

  def get_files(path) do
    path = path <> "/**/*.md"
    Logger.info "Searching files using '#{path}' with cwd '#{System.cwd}'"
    files = Path.wildcard path
    Logger.info "Found files:"
    for file <- files do
      Logger.info file
    end
    files
  end

  def parse(file) do
    File.read!(file)
    |> Parser.parse(Path.basename file)
  end

  def handle_responses(tasklist) do
    Enum.map tasklist, fn task -> Task.await task end
  end

  def construct_archives(datalist) do
    Enum.reduce datalist, %{pages: %{}, posts: [], years: %{}, months: %{}, tags: %{}}, fn pagedata, acc ->
      case pagedata.__struct__ do
        Page -> %{acc | pages: Map.put(acc.pages, pagedata.slug, pagedata)}

        Post ->
          {year, month, _} = pagedata.date

          tags = Enum.reduce pagedata.tags, acc.tags, fn tag, tagmap ->
            posts = Map.get(tagmap, tag, [])
            Map.put(tagmap, tag, [pagedata | posts])
          end

          year_posts = [pagedata | Map.get(acc.years, year, [])]
          month_posts = [pagedata | Map.get(acc.months, {year, month}, [])]

          %{
            acc |
            posts: [pagedata | acc.posts],
            years: Map.put(acc.years, year, year_posts),
            months: Map.put(acc.months, {year, month}, month_posts),
            tags: tags
          }
      end
    end
  end
end