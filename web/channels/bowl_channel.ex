defmodule CodeFishbowl.BowlChannel do
  use Phoenix.Channel

  intercept ["editor_change"]

  def join("bowl:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("editor_change", %{"body" => body, "row" => row, "column" => column}, socket) do
    broadcast! socket, "editor_change", %{body: body, row: row, column: column}
    {:noreply, socket}
  end

  def handle_out("editor_change", payload, socket) do
    push socket, "editor_change", payload
    {:noreply, socket}
  end
end
