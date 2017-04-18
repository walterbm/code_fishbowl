defmodule BowlCache.Cache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :bowl_cache_table},
      {:log_limit, 1_000_000}
    ], opts)
  end

  def fetch(id) do
    get(id)
  end

  def fetch(id, default) do
    case get(id) do
      {:ok, result} -> {:ok, result}
      {:error, _} -> save(id, default)
    end
  end

  def save(id, value) do
    set(id, value)
    {:ok, value}
  end

  def update(id, value) do
    case get(id) do
      {:ok, result} -> set(id, Map.merge(result,value))
      error -> error
    end
  end

  defp get(id) do
    case GenServer.call(__MODULE__, {:get, id}) do
      [] -> {:error, :not_found}
      [{_id, result}] -> {:ok, result}
    end
  end

  defp set(id, value) do
    GenServer.call(__MODULE__, {:set, id, value})
  end

  # GenServer callbacks

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  def handle_call({:get, id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, id)
    {:reply, result, state}
  end

  def handle_call({:set, id, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {id, value})
    {:reply, value, state}
  end

end
