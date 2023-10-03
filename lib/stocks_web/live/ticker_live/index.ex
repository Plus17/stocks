defmodule StocksWeb.TickerLive.Index do
  use StocksWeb, :live_view

  alias Stocks.Contexts.Stocks.StockFinder

  def mount(_params, _session, socket) do
    params = %{"ticker" => ""}
    {:ok, assign(socket, ticker: nil, form: to_form(params), historical: [], graph_data: [])}
  end

  def render(assigns) do
    ~H"""
    <h1>Enter Stock Ticker</h1>

    <.simple_form for={@form} id="ticker-form" phx-submit="search">
      <.input field={@form[:ticker]} label="Ticker" />

      <:actions>
        <.button phx-disable-with="Saving...">Search</.button>
      </:actions>
    </.simple_form>
    <!-- Show the result for the ticker -->
    <%= if @ticker do %>
      <div id="results">
        <.list>
          <:item title="Symbol"><%= @ticker.symbol %></:item>
          <:item title="Close"><%= @ticker.close %></:item>
          <:item title="Requested at"><%= @ticker.requested_at %></:item>
        </.list>
      </div>
    <% end %>
    <!-- Place to render the graph -->
    <canvas
      id="graph"
      data-dates={Enum.join(@historical |> Enum.map(& &1.requested_at), ",")}
      data-prices={Enum.join(@historical |> Enum.map(& &1.close), ",")}
      phx-hook="ChartHook"
    >
    </canvas>
    <!-- Show the historical data -->
    <.table id="historical_data" rows={@historical}>
      <:col :let={ticker} label="Symbol"><%= ticker.symbol %></:col>
      <:col :let={ticker} label="Open"><%= ticker.close %></:col>
      <:col :let={ticker} label="Close"><%= ticker.close %></:col>
      <:col :let={ticker} label="Date"><%= ticker.requested_at %></:col>
      <:col :let={ticker} label="ID"><%= ticker.id %></:col>
    </.table>
    """
  end

  def handle_event("search", %{"ticker" => ticker}, socket) do
    ticker = String.upcase(ticker)

    case StockFinder.find_stock(ticker) do
      {:ok, ticker_data} ->
        historical = StockFinder.fetch_historical_data(ticker)

        push_event(socket, "update-chart", %{
          labels: Enum.map(historical, & &1.requested_at),
          data: Enum.map(historical, & &1.close)
        })

        {:noreply, assign(socket, ticker: ticker_data, historical: historical)}

      {:error, :invalid_ticker} ->
        {:noreply, put_flash(socket, :error, "Invalid ticker")}
    end
  end
end
