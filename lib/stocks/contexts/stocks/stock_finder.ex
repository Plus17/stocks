defmodule Stocks.Contexts.Stocks.StockFinder do
  @moduledoc """
  Provides functions for finding stocks. This is the public API for the Stocks.
  """

  alias Stocks.Managers.Tickers.TickerManager

  @doc """
  Finds a stock by ticker.
  ## Examples
      iex> find_stock("AAPL")
      {:ok, %Stock{}}
      iex> find_stock("BAD")
      {:error, :invalid_ticker}
  """
  @spec find_stock(String.t()) :: {:ok, map()} | {:error, any()}
  def find_stock(ticker) do
    with {:ok, stock} <- stock_client!().fetch_stock_data(ticker) do
      TickerManager.create(stock)
    end
  end

  def stock_client!() do
    Stocks.config!([:stock_client])
  end
end
