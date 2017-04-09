defmodule CodeFishbowl.PageController do
  use CodeFishbowl.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
