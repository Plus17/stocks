defmodule Stocks.Factory do
  @moduledoc """
  Factory module configuration for global factories
  """

  use ExMachina.Ecto, repo: Stocks.Repo

  use Stocks.UserFactory

  def valid_user_password, do: "hello world!"
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
end
