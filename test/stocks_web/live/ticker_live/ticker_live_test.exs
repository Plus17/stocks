defmodule StocksWeb.TickerLiveTest do
  use StocksWeb.ConnCase, async: false

  import Phoenix.LiveViewTest

  import Mox

  setup do
    Application.put_env(:stocks, :stock_client, Stocks.HTTP.StooqClientMock)

    :ok
  end

  setup :verify_on_exit!

  describe "Index" do
    test "show stock ticker data", %{conn: conn} do
      tickers = insert_list(4, :ticker, symbol: "VOO.US")

      expect(Stocks.HTTP.StooqClientMock, :fetch_stock_data, fn _url, ticker ->
        assert ticker == "VOO"

        {:ok, build(:ticker, close: Decimal.new("9999"))}
      end)

      {:ok, index_live, _html} = live(conn, ~p"/stocks")

      assert index_live
             |> form("#ticker-form", ticker: "VOO")
             |> render_submit()

      assert has_element?(index_live, "#results")

      html = render(index_live)
      assert html =~ "9999"
      for ticker <- tickers do
        assert html =~ ticker.id
      end
    end
  end
end
