defmodule CodeFishbowl.BowlController do
  use CodeFishbowl.Web, :controller

  alias BowlCache.Cache

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    redirect conn, to: "/bowls/#{bowl_hash()}"
  end

  def show(conn, %{"bowl" => _bowl}) do
    render conn, "show.html"
  end

  defp bowl_hash() do
    hash = gen_bowl_hash()
    if Cache.exists?(hash) do
      bowl_hash()
    else
      hash
    end
  end

  defp gen_bowl_hash() do
    :crypto.strong_rand_bytes(7)
    |> Base.encode32(padding: false)
    |> binary_part(0, 7)
  end

end
