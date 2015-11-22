defmodule MebeWeb.RequestStartTimePlug do
  import Plug.Conn

  @data_key :request_start_time

  @time_units [
    "µs", "ms", "s"
  ]

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> assign(@data_key, get_current_time)
  end

  def calculate_time(conn) do
    old_time = conn.assigns[@data_key]
    
    ((get_current_time() - old_time) * 1_000_000)
    |> Float.round()
    |> trunc()
    |> get_unit(@time_units)
  end

  defp get_current_time() do
    {millions, seconds, microseconds} = :os.timestamp
    (millions * 1_000_000) + seconds + (microseconds / 1_000_000)
  end

  defp get_unit(value, [unit]), do: {value, unit}

  defp get_unit(value, [_ | units]) when value > 1_000, do: get_unit(value / 1_000, units)

  defp get_unit(value, [unit | _]), do: {value, unit}
end
