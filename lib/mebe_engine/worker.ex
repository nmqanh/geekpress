defmodule MebeEngine.Worker do
  @moduledoc """
  This worker initializes the post database and keeps it alive while the server is running.
  """
  use GenServer
  require Logger

  alias MebeEngine.Crawler
  alias MebeEngine.DB

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    load_db
    if Mix.env == :dev do
      :fs.start_link(:fs_watcher, System.get_env("BLOG_PATH"))
      :fs.subscribe(:fs_watcher)
    end
    {:ok, nil}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, socket) do
    Logger.info "Folder Changed Detected! Reloading..."
    refresh_db
    {:noreply, socket}
  end

  def handle_call(:refresh, _from, nil) do
    refresh_db
    {:reply, :ok, nil}
  end

  def refresh_db() do
    Logger.info "Destroying database…"
    DB.destroy
    Logger.info "Reloading database…"
    load_db
    Logger.info "Update done!"
  end

  @doc """
  Initialize the database by crawling the configured path and parsing data to the DB.
  """
  def load_db() do
    Logger.info "Loading post database from '#{System.get_env("BLOG_PATH")}'…"

    %{
      pages: pages,
      posts: posts,
      tags: tags,
      years: years,
      months: months,
    } = Crawler.crawl System.get_env("BLOG_PATH")

    Logger.info "Loaded #{Enum.count pages} pages and #{Enum.count posts} posts."

    DB.init

    DB.insert_posts posts
    DB.insert_count :all, Enum.count posts

    Enum.each Map.keys(pages), fn page -> DB.insert_page pages[page] end

    Enum.each Map.keys(tags),
      fn tag ->
        Enum.each(tags[tag], fn post -> DB.insert_tag_post(tag, post) end)
        DB.insert_count tag, Enum.count tags[tag]
      end

    # For years and months, only insert the counts (the data can be fetched from main posts table)
    Enum.each Map.keys(years), fn year -> DB.insert_count year, Enum.count years[year] end
    Enum.each Map.keys(months), fn month -> DB.insert_count month, Enum.count months[month] end

    Logger.info "Posts loaded."
  end
end
