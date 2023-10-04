## Development with Docker

### Dependencies

1. Install [Docker](https://www.docker.com/products/docker-desktop)
2. Install Make: `sudo apt install make` or `brew install make`

### First run

1. Clone the project repository: `git clone git@github.com:Plus17/stocks.git`
2. Go to project dir: `cd stocks`
3. Execute: `make setup` to install dependencies, setup the database, execute migrations, etc.
4. Get a `.env` file executing `cp env.template .env` and set the `SECRET_KEY_BASE` value. Get a new value executing `make gen.secret`
5. Execute: `make run` to run the server at http://localhost:4000

## Development without Docker

### Dependencies

1. Install [asdf](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
2. Add the [asdf erlang plugin](https://github.com/asdf-vm/asdf-erlang) `asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git`
3. Add the [asdf elixir plugin](https://github.com/asdf-vm/asdf-elixir) `asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git`
4. Install [fnm](https://github.com/Schniz/fnm) `curl -fsSL https://fnm.vercel.app/install | bash`
### First run

1. Clone the project repository: `git clone git@github.com:Plus17/stocks.git`
2. Go to project dir: `cd stocks`
3. Install Erlang, Elixir & NodeJS using the `.tools-versions` file with: `asdf install`
4. Install NodeJs usign the `.node-version` file with `fnm install`
5. Copy the `env.dist` file to `.env` and set the `SECRET_KEY_BASE` value. Get a new value executing `mix phx.gen.secret`.
6. Run `export $(cat .env | xargs)` on project root folder
7. Run `mix local.hex && mix local.rebar`
8. Run `mix setup` to download dependencies & setup database
9. Run `mix phx.server`

# Stocks**

Visit [`localhost:4000`](http://localhost:4000) from your browser.

![image](https://github.com/Plus17/stocks/assets/8551125/220864ac-bac8-473e-bd79-0f2a1f28102f)

![image](https://github.com/Plus17/stocks/assets/8551125/3251ff3f-9ac9-4edf-bdcc-a5c8a1cac53f)

## Basic module interaction


### Get ticker data

```
                                                        ┌──────────────────┐ 
                                                        │                  │ 
                                                        │   StooqClient    │ 
                                                        │                  │ 
                                     ┌─────────────────▶│fetch_stock_data/3│ 
                                     │                  │                  │ 
                                     │                  │                  │ 
┌──────────────────┐                 │                  └──────────────────┘ 
│                  │                 │                                       
│   TickerFinder   │                 │                                       
│                  │─────────────────┤                                       
│   find_stock/2   │                 │                                       
│                  │                 │                                       
└──────────────────┘                 │                                       
                                     │                                       
                                     │                  ┌───────────────────┐
                                     │                  │                   │
                                     │                  │   TickerManager   │
                                     └─────────────────▶│                   │
                                                        │     insert/1      │
                                                        │                   │
                                                        └───────────────────┘
```

### Get historical data for ticker

```
┌───────────────────────────┐       ┌─────────────────────┐
│                           │       │                     │
│       TickerFinder        │       │    TickerManager    │
│                           │──────▶│                     │
│  fetch_historical_data/1  │       │       list/1        │
│                           │       │                     │
└───────────────────────────┘       └─────────────────────┘
```
