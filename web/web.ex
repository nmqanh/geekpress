defmodule MebeWeb.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MebeWeb.Web, :controller
      use MebeWeb.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller

      # Import URL helpers from the router
      import MebeWeb.Router.Helpers
    end
  end

  def view do
    quote do
      root = "web/templates"

      # Check if we should be using a custom template
      custom_templates = Application.get_env :mebe_web, :custom_templates
      compiled_view = MebeWeb.Web.module_to_str __MODULE__

      if Map.get custom_templates, compiled_view do
        root = root <> "/custom"
      end

      use Phoenix.View, root: root

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2]

      # Import URL helpers from the router
      import MebeWeb.Router.Helpers

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def module_to_str(module) do
    module
      |> Atom.to_string
      |> String.split(".")
      |> List.last
  end
end
