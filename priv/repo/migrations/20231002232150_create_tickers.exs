defmodule Stocks.Repo.Migrations.CreateTickers do
  use Ecto.Migration

  def change do
    create table(:tickers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :requested_at, :utc_datetime
      add :symbol, :string
      add :close, :decimal
      add :high, :decimal
      add :low, :decimal
      add :open, :decimal
      add :volume, :integer

      timestamps()
    end
  end
end
