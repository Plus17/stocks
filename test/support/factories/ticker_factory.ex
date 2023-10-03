

defmodule Stocks.TickerFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ticker` context.
  """

  alias Stocks.Schemas.Tickers.Ticker

  defmacro __using__(_opts) do
    quote do
      def ticker_factory() do
        %Ticker{
          requested_at: ~N[2023-10-01 23:21:00],
          close: 392.67,
          high: 393.7599,
          low: 389.97,
          open: 391.9,
          symbol: "VOO.US",
          volume: 5878250
        }
      end
    end
  end
end
