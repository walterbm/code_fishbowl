defmodule CodeFishbowl.BowlControllerTest do
  use CodeFishbowl.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Code Fishbowl"
  end
end
