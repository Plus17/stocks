defmodule Stocks.Schemas.Tickers.Ticker do
  @moduledoc """
   The tickers schema module.
  """
  use Stocks.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          requested_at: DateTime.t(),
          symbol: String.t(),
          close: Decimal.t(),
          high: Decimal.t(),
          low: Decimal.t(),
          open: Decimal.t(),
          volume: integer(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

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
