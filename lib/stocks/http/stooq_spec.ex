defmodule Stocks.HTTP.StooqSpec do
  @moduledoc """
  Defines the contract for interacting with the Stooq API.
  """

  alias Stocks.Schemas.Tickers.Ticker

  @typedoc """
  The ticker for a stock. For example, "AAPL" for Apple.
  """
  @type ticker :: String.t()

  @type base_url :: String.t()

  @type req_error ::
          {:error,
           :invalid_ticker | {:transport_error, any} | {:unexpected_status_code, non_neg_integer}}

  @doc """
  Fetches stock data for the given ticker.

  Returns `{:ok, data}` if the ticker is valid and the data was fetched successfully.
  Returns `{:error, :invalid_ticker}` if the ticker is invalid.
  Returns `{:error, {:transport_error, reason}}` if there was a transport error.
  Returns `{:error, {:unexpected_status_code, status}}` if the response status code was not 200.

  ## Examples

      iex> fetch_stock_data("AAPL")
      {:ok, %Ticker{}}
      iex> fetch_stock_data("BAD")
      {:error, :invalid_ticker}
  """
  @callback fetch_stock_data(base_url, ticker) :: {:ok, Ticker.t()} | {:error, any()}
end
