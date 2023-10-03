defmodule Stocks.Contexts.Stocks.StockFinderTest do
  use Stocks.DataCase, async: true

  alias Stocks.Schemas.Tickers.Ticker

  alias Stocks.Contexts.Stocks.StockFinder

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "find_stock/1" do
    test "when ticker exists returns data", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert conn.method == "GET"

        conn
        |> Plug.Conn.merge_resp_headers([{"content-type", "application/json"}])
        |> Plug.Conn.resp(
          200,
          ~s<{"symbols":[{"symbol":"AAPL.US","date":"2023-10-03","time":"21:12:30","open":172.255,"high":173.63,"low":170.82,"close":172.01,"volume":28168857}]}>
        )
      end)

      expected_data = %{
        close: Decimal.new("172.01"),
        high: Decimal.new("173.63"),
        low: Decimal.new("170.82"),
        open: Decimal.new("172.255"),
        requested_at: ~U[2023-10-03 21:12:30Z],
        symbol: "AAPL.US",
        volume: 28_168_857
      }

      {:ok, %Ticker{} = ticker} = StockFinder.find_stock("AAPL", base_url(bypass.port))

      assert ticker.close == expected_data.close
      assert ticker.high == expected_data.high
      assert ticker.low == expected_data.low
      assert ticker.open == expected_data.open
      assert ticker.requested_at == expected_data.requested_at
      assert ticker.symbol == expected_data.symbol
      assert ticker.volume == expected_data.volume
    end

    test "when ticker does not exists returns error", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert conn.method == "GET"

        conn
        |> Plug.Conn.merge_resp_headers([{"content-type", "application/json"}])
        |> Plug.Conn.resp(200, ~s<{"symbols":[{"symbol":"BAD.US"}]}>)
      end)

      assert StockFinder.find_stock("BAD", base_url(bypass.port)) == {:error, :invalid_ticker}
    end
  end

  describe "fetch_historical_data/1" do
    test "returns rows for ticker" do
      insert(:ticker, symbol: "VOO.US")
      ticker = insert(:ticker, symbol: "AAPL.US")

      assert StockFinder.fetch_historical_data("AAPL") == [ticker]
    end
  end

  defp base_url(port), do: "http://localhost:#{port}/q/l/"
end
