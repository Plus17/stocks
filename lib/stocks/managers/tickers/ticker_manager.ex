defmodule Stocks.Managers.Tickers.TickerManager do
  @moduledoc """
  The Contexts.Tickers.TickerManager Manager.
  """

  import Ecto.Query, warn: false
  alias Stocks.Repo

  alias Stocks.Schemas.Tickers.Ticker

  @doc """
  Returns the list of tickers.
  ## Examples
      iex> list()
      [%Ticker{}, ...]
  """
  def list do
    Repo.all(Ticker)
  end

  @doc """
  Gets a single ticker.
  Raises `Ecto.NoResultsError` if the Ticker does not exist.
  ## Examples
      iex> get!(123)
      %Ticker{}
      iex> get!(456)
      ** (Ecto.NoResultsError)
  """
  def get!(id), do: Repo.get!(Ticker, id)

  @doc """
  Creates a ticker.
  ## Examples
      iex> create(%{field: value})
      {:ok, %Ticker{}}
      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create(attrs \\ %{}) do
    %Ticker{}
    |> Ticker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticker changes.
  ## Examples
      iex> change(ticker)
      %Ecto.Changeset{data: %Ticker{}}
  """
  def change(%Ticker{} = ticker, attrs \\ %{}) do
    Ticker.changeset(ticker, attrs)
  end
end
