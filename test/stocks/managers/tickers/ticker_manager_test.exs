defmodule Stocks.Contexts.Tickers.TickerManagerTest do
  use Stocks.DataCase, async: true

  alias Stocks.Managers.Tickers.TickerManager

  alias Stocks.Schemas.Tickers.Ticker

  @invalid_attrs %{requested_at: nil, symbol: nil}

  test "list/0 returns all tickers" do
    ticker = insert(:ticker)
    assert TickerManager.list() == [ticker]
  end

  test "get!/1 returns the ticker with given id" do
    ticker = insert(:ticker)
    assert TickerManager.get!(ticker.id) == ticker
  end

  describe "create/1" do
    test "with valid data creates a ticker" do
      valid_attrs = params_for(:ticker)

      assert {:ok, %Ticker{} = ticker} = TickerManager.create(valid_attrs)
      assert ticker.requested_at == ~U[2023-10-01 23:21:00Z]
      assert ticker.close == Decimal.new("392.67")
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = TickerManager.create(@invalid_attrs)

      assert errors_on(changeset) == %{
               close: ["can't be blank"],
               high: ["can't be blank"],
               low: ["can't be blank"],
               open: ["can't be blank"],
               requested_at: ["can't be blank"],
               symbol: ["can't be blank"],
               volume: ["can't be blank"]
             }
    end
  end

  test "change/1 returns a ticker changeset" do
    ticker = insert(:ticker)
    assert %Ecto.Changeset{} = TickerManager.change(ticker)
  end
end
