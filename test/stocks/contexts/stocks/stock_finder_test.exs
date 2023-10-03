defmodule Stocks.Contexts.Stocks.StockFinderTest do
  use Stocks.DataCase, async: true

  import Mox

  alias Stocks.Schemas.Tickers.Ticker

  alias Stocks.Contexts.Stocks.StockFinder

  alias Stocks.HTTP.StooqClientMock

  setup :verify_on_exit!

  describe "find_stock/1" do
    test "when ticker exists returns data" do
      expect(StooqClientMock, :fetch_stock_data, fn ticker ->
        assert ticker == "AAPL"

        {:ok,
         %{
           "close" => 392.67,
           "date" => "2023-10-02",
           "high" => 393.7599,
           "low" => 389.97,
           "open" => 391.9,
           "symbol" => "VOO.US",
           "time" => "22:00:09",
           "volume" => 5_878_250,
           "requested_at" => "2023-10-02 22:00:09"
         }}
      end)

      expected_data = %{
        close: Decimal.new("392.67"),
        high: Decimal.new("393.7599"),
        low: Decimal.new("389.97"),
        open: Decimal.new("391.9"),
        requested_at: ~U[2023-10-02 22:00:09Z],
        symbol: "VOO.US",
        volume: 5_878_250
      }

      {:ok, %Ticker{} = ticker} = StockFinder.find_stock("AAPL")

      assert ticker.close == expected_data.close
      assert ticker.high == expected_data.high
      assert ticker.low == expected_data.low
      assert ticker.open == expected_data.open
      assert ticker.requested_at == expected_data.requested_at
      assert ticker.symbol == expected_data.symbol
      assert ticker.volume == expected_data.volume
    end
  end
end
