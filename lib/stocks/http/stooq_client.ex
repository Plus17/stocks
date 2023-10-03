defmodule Stocks.HTTP.StooqClient do
  @moduledoc """
  Implements the StooqSpec behavior to interact with the Stooq API over HTTP.

  Valid options:

    * `:format` - The format of the response. Defaults to `"json"`.
  """
  @behaviour Stocks.HTTP.StooqSpec

  require Logger

  alias Stocks.HTTP.StooqSpec

  alias Stocks.Schemas.Tickers.Ticker

  alias Stocks.Managers.Tickers.TickerManager

  @default_opts [format: "json"]

  @impl true
  @spec fetch_stock_data(String.t(), StooqSpec.ticker(), Keyword.t() | nil) ::
          {:ok, Ticker.t()} | StooqSpec.req_error()
  def fetch_stock_data(base_url, ticker, opts \\ @default_opts) do
    format = Keyword.get(opts, :format, "json")
    url = "#{base_url}?s=#{ticker}.us&f=sd2t2ohlcv&h&e=#{format}"

    case Req.get(url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        process_body(body)

      {:ok, %Req.Response{status: status}} ->
        Logger.error("[StooqAPI.fetch_stock_data] Unexpected status code: #{status}")
        {:error, {:unexpected_status_code, status}}

      {:error, %Mint.TransportError{reason: reason}} ->
        Logger.error("[StooqAPI.fetch_stock_data] Transport error: #{inspect(reason)}")
        {:error, {:transport_error, reason}}
    end
  end

  @spec process_body(map) :: {:ok, map} | {:error, :invalid_ticker}
  defp process_body(body) do
    data =
      body
      |> Map.fetch!("symbols")
      |> List.first()

    case Map.get(data, "time") do
      nil ->
        Logger.warn(fn -> "[StooqAPI.process_body] Invalid ticker: #{inspect(data)}" end)
        {:error, :invalid_ticker}

      _req_time ->
        {:ok, build_ticker(data)}
    end
  end

  @spec build_ticker(map) :: Ticker.t()
  defp build_ticker(data) do
    data = Map.put(data, "requested_at", "#{data["date"]} #{data["time"]}")

    %Ticker{}
    |> TickerManager.change(data)
    |> Ecto.Changeset.apply_changes()
  end
end
