Mox.defmock(Stocks.HTTP.StooqClientMock, for: Stocks.HTTP.StooqSpec)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Stocks.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
