defmodule MebeEngine.DB do
  @moduledoc """
  Stuff related to storing the blog data to memory (ETS).
  """

  # Table for meta information, like the counts of posts
  @meta_table :meta

  # Table for storing pages by slug
  @page_table :pages

  # Table for sequential retrieval of posts (for list pages)
  @post_table :posts

  # Table for quick retrieval of single post (with key)
  @single_post_table :single_posts

  # Table for storing posts with tag as first element of key
  @tag_table :tags

  def init() do
    # Only create tables if they don't exist already
    if (:ets.info @meta_table) == :undefined do
      :ets.new @meta_table,         [:named_table, :set,          :protected, read_concurrency: true]
      :ets.new @page_table,         [:named_table, :set,          :protected, read_concurrency: true]
      :ets.new @post_table,         [:named_table, :ordered_set,  :protected, read_concurrency: true]
      :ets.new @single_post_table,  [:named_table, :set,          :protected, read_concurrency: true]
      :ets.new @tag_table,          [:named_table, :ordered_set,  :protected, read_concurrency: true]
    end
  end

  def destroy() do
    :ets.delete_all_objects @meta_table
    :ets.delete_all_objects @page_table
    :ets.delete_all_objects @post_table
    :ets.delete_all_objects @single_post_table
    :ets.delete_all_objects @tag_table
  end

  def insert_count(key, count) do
    :ets.insert @meta_table, {key, count}
  end

  def insert_posts(posts) do
    ordered_posts = Enum.map posts, fn post ->
      {year, month, day} = post.date
      {{year, month, day, post.order}, post}
    end

    single_posts = Enum.map posts, fn post ->
      {year, month, day} = post.date
      {{year, month, day, post.slug}, post}
    end

    :ets.insert @post_table, ordered_posts
    :ets.insert @single_post_table, single_posts
  end

  def insert_page(page) do
    :ets.insert @page_table, {page.slug, page}
  end

  def insert_tag_post(tag, post) do
    {year, month, day} = post.date
    :ets.insert @tag_table, {{tag, year, month, day, post.order}, post}
  end


  def get_reg_posts(first, last) do
    get_post_list @post_table, [{:"$1", [], [:"$_"]}], first, last
  end

  def get_tag_posts(tag, first, last) do
    get_post_list @tag_table, [{{{tag, :_, :_, :_, :_}, :"$1"}, [], [:"$_"]}], first, last
  end

  def get_year_posts(year, first, last) do
    get_post_list @post_table, [{{{year, :_, :_, :_}, :"$1"}, [], [:"$_"]}], first, last
  end

  def get_month_posts(year, month, first, last) do
    get_post_list @post_table, [{{{year, month, :_, :_}, :"$1"}, [], [:"$_"]}], first, last
  end

  def get_page(slug) do
    case :ets.match_object @page_table, {slug, :"$1"} do
      [{_, page}] -> page
      _ -> nil
    end
  end

  def get_post(year, month, day, slug) do
    case :ets.match_object @single_post_table, {{year, month, day, slug}, :"$1"} do
      [{_, post}] -> post
      _ -> nil
    end
  end

  def get_count(type) do
    case :ets.match_object @meta_table, {type, :"$1"} do
      [{_, count}] -> count
      [] -> 0
    end
  end




  # Combine error handling of different post listing functions
  defp get_post_list(table, matchspec, first, last) do
    case :ets.select_reverse table, matchspec, first + last do
      :"$end_of_table" -> []

      {result, _} ->
        {_, result} = Enum.split result, first
        ets_to_data result
    end
  end

  # Remove key from data returned from ETS
  defp ets_to_data(data) do
    Enum.map data, fn {_, actual} -> actual end
  end
end
