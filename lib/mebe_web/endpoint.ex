defmodule MebeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mebe_web

  # Serve at "/" the given assets from "priv/static" directory
  plug Plug.Static,
    at: "/", from: :mebe_web,
    only: ~w(css images js fonts favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_mebe_web_key",
    signing_salt: "WWhqeGIn"

  plug MebeWeb.Router
end
