defmodule Stocks.Schemas.Tickers.Ticker do
  @moduledoc """
   The tickers schema module.
  """
  use Stocks.Schema
  import Ecto.Changeset

  schema "tickers" do
    field :requested_at, :utc_datetime
    field :symbol, :string
    field :close, :decimal
    field :high, :decimal
    field :low, :decimal
    field :open, :decimal
    field :volume, :integer

    timestamps()
  end

  @required [:requested_at, :symbol, :close, :high, :low, :open, :volume]
  @optional []

  @doc false
  def changeset(ticker, attrs) do
    ticker
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
