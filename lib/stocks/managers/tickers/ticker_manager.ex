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
  @spec list(Keyword.t() | nil) :: [Ticker.t()] | []
  def list(filters \\ []) do
    Ticker
    |> where([t], ^filters)
    |> Repo.all()
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
  @spec get!(binary()) :: Ticker.t()
  def get!(id), do: Repo.get!(Ticker, id)

  @doc """
  Creates a ticker.
  ## Examples
      iex> create(%{field: value})
      {:ok, %Ticker{}}
      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec create(map() | nil) :: {:ok, Ticker.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %Ticker{}
    |> Ticker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts a ticker struct.
  ## Examples
      iex> insert(%Ticker{})
      {:ok, %Ticker{}}
      iex> insert(%Ticker{})
      {:error, %Ecto.Changeset{}}
  """
  @spec insert(Ticker.t()) :: {:ok, Ticker.t()} | {:error, Ecto.Changeset.t()}
  def insert(%Ticker{} = ticker) do
    Repo.insert(ticker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticker changes.
  ## Examples
      iex> change(ticker)
      %Ecto.Changeset{data: %Ticker{}}
  """
  @spec change(Ticker.t(), map() | nil) :: Ecto.Changeset.t()
  def change(%Ticker{} = ticker, attrs \\ %{}) do
    Ticker.changeset(ticker, attrs)
  end
end
