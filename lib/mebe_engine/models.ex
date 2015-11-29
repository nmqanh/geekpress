defmodule MebeEngine.Models do
  @moduledoc """
  This module contains the data models (not db models) of the blog engine.
  """

  defmodule PageData do
    defstruct filename: nil,
      headers: %{},
      content: nil
  end

  defmodule Post do
    defstruct slug: nil,
      title: nil,
      description: nil,
      date: nil,
      tags: [],
      content: nil,
      short_content: nil,
      order: 0,
      has_more: false,
      author: "",
      feature_image: nil
  end

  defmodule Page do
    defstruct slug: nil,
      title: nil,
      description: nil,
      content: nil,
      author: "",
      feature_image: nil
  end
end
