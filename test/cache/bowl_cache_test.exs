defmodule CodeFishbowl.BowlCacheTest do
  use ExUnit.Case

  setup do
    Supervisor.terminate_child(CodeFishbowl.Supervisor, BowlCache.Supervisor)
    Supervisor.restart_child(CodeFishbowl.Supervisor, BowlCache.Supervisor)
    :ok
  end

  test "caches and finds the correct data" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    assert BowlCache.Cache.fetch("A") == {:error, :not_found}
    BowlCache.Cache.save("A", mock_bowl)

    assert BowlCache.Cache.fetch("A") == {:ok, mock_bowl}
  end

  test "sets a default value if key is not found" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    assert BowlCache.Cache.fetch("A") == {:error, :not_found}
    assert BowlCache.Cache.fetch("A", mock_bowl) == {:ok, mock_bowl}

    assert BowlCache.Cache.fetch("A") == {:ok, mock_bowl}
  end

  test "correctly updates cache" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    BowlCache.Cache.save("A", mock_bowl)
    assert BowlCache.Cache.fetch("A") == {:ok, mock_bowl}

    updated = %{lang: "python"}

    updated_bowl = Map.merge(mock_bowl, updated)

    assert BowlCache.Cache.update("A", updated_bowl) == updated_bowl
    assert BowlCache.Cache.fetch("A") == {:ok, updated_bowl}
  end

end
