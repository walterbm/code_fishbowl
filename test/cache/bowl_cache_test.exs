defmodule CodeFishbowl.BowlCacheTest do
  use ExUnit.Case

  setup do
    Supervisor.terminate_child(CodeFishbowl.Supervisor, BowlCache.Supervisor)
    Supervisor.restart_child(CodeFishbowl.Supervisor, BowlCache.Supervisor)
    :ok
  end

  test "can cache and find the correct data" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    assert BowlCache.Cache.fetch("A") == {:error, :not_found}
    BowlCache.Cache.save("A", mock_bowl)

    assert BowlCache.Cache.fetch("A") == {:ok, mock_bowl}
  end

  test "can set a default value if key is not found" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    assert BowlCache.Cache.fetch("A") == {:error, :not_found}
    assert BowlCache.Cache.fetch("A", mock_bowl) == {:ok, mock_bowl}

    {:ok, [[result, _timestamp]]} = BowlCache.Cache.fetch_all("A")
    assert result == mock_bowl
  end

  test "can correctly detects existing keys" do
    mock_bowl_one = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}
    mock_bowl_two = %{body: "var test = 42;", row: "4", column: "6", lang: "javascript"}
    mock_bowl_three = %{body: "let test(Int) = 42", row: "1", column: "6", lang: "swift"}

    assert BowlCache.Cache.exists?("A") == false
    BowlCache.Cache.save("A", mock_bowl_one)
    BowlCache.Cache.save("A", mock_bowl_two)
    BowlCache.Cache.save("A", mock_bowl_three)

    {:ok, results} = BowlCache.Cache.fetch_all("A")
    assert results |> Enum.count == 3
    assert results |> Enum.map(fn [data | _timestamp] -> data end) == [mock_bowl_one, mock_bowl_two, mock_bowl_three]
  end

  test "can handle mutiple non-duplicate data per key" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    assert BowlCache.Cache.exists?("A") == false
    BowlCache.Cache.save("A", mock_bowl)

    assert BowlCache.Cache.exists?("A") == true
  end

  test "can update cache by using new and latest data" do
    mock_bowl = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}

    BowlCache.Cache.save("A", mock_bowl)
    {:ok, [[result, _timestamp]]} = BowlCache.Cache.fetch_all("A")
    assert result == mock_bowl

    updated = %{lang: "python"}

    updated_bowl = Map.merge(mock_bowl, updated)

    assert BowlCache.Cache.update("A", updated_bowl) == updated_bowl
    {:ok, results} = BowlCache.Cache.fetch_all("A")
    assert results |> Enum.count == 2
    assert results |> List.last |> List.first == updated_bowl
  end

  test "can fetch latest data for a given key" do
    mock_bowl_one = %{body: "var test = 42", row: "1", column: "6", lang: "javascript"}
    mock_bowl_two = %{body: "var test = 42;", row: "4", column: "6", lang: "javascript"}
    mock_bowl_three = %{body: "let test(Int) = 42", row: "1", column: "6", lang: "swift"}

    assert BowlCache.Cache.exists?("A") == false
    BowlCache.Cache.save("A", mock_bowl_one)
    BowlCache.Cache.save("A", mock_bowl_two)
    BowlCache.Cache.save("A", mock_bowl_three)
    assert BowlCache.Cache.fetch("A") == {:ok, mock_bowl_three}
  end

end
