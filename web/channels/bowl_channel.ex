defmodule CodeFishbowl.BowlChannel do
  use Phoenix.Channel

  def join("bowl:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("bowl:" <> _bowl_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("editor_change", %{"body" => body, "row" => row, "column" => column}, socket) do
    broadcast! socket, "editor_change", %{body: body, row: row, column: column}
    {:noreply, socket}
  end

  def handle_in("lang_change", %{"lang" => lang}, socket) do
    broadcast! socket, "lang_change", %{lang: lang}
    {:noreply, socket}
  end

end
