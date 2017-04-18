defmodule BowlCache.Cache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :bowl_cache_table},
      {:log_limit, 1_000_000}
    ], opts)
  end

  def fetch(id) do
    get_latest(id)
  end
  def fetch(id, default) do
    case get_latest(id) do
      {:ok, results} -> {:ok, results}
      {:error, _} -> save(id, default)
    end
  end

  def fetch_all(id) do
    get(id)
  end

  def save(id, value) do
    set(id, value)
    {:ok, value}
  end

  def update(id, value) do
    case get_latest(id) do
      {:ok, result} -> set(id, Map.merge(result, value))
      error -> error
    end
  end

  def exists?(id) do
    member(id)
  end

  defp get_latest(id) do
    case get(id) do
      {:ok, results} ->
        [data, _timestamp] = List.last(results)
        {:ok, data}
      error -> error
    end
  end

  defp get(id) do
    case GenServer.call(__MODULE__, {:get, id}) do
      [] -> {:error, :not_found}
      results -> {:ok, results}
    end
  end

  defp member(id) do
    GenServer.call(__MODULE__, {:member, id})
  end

  defp set(id, value) do
    GenServer.call(__MODULE__, {:set, id, value, :os.system_time(:millisecond)})
  end

  # GenServer callbacks

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :bag, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end

  def handle_call({:get, id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.match(ets_table_name, {id, :"$1", :"$2"})
    {:reply, result, state}
  end

  def handle_call({:member, id}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.member(ets_table_name, id)
    {:reply, result, state}
  end

  def handle_call({:set, id, value, timestamp}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {id, value, timestamp})
    {:reply, value, state}
  end

end
