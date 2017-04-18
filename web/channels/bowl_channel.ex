defmodule CodeFishbowl.BowlChannel do
  use Phoenix.Channel

  alias BowlCache.Cache
  alias CodeFishbowl.Bowl

  def join("bowl:" <> bowl_id, _params, socket) do
    socket = assign(socket, :bowl_id, bowl_id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, bowl} = Cache.fetch(socket.assigns.bowl_id, Bowl.default)

    push socket, "editor_set", bowl
    {:noreply, socket}
  end

  def handle_in("editor_change", %{"body" => body, "row" => row, "column" => column}, socket) do
    update = %{body: body, row: row, column: column}
    Cache.update(socket.assigns.bowl_id, update)

    broadcast! socket, "editor_change", update
    {:noreply, socket}
  end

  def handle_in("lang_change", %{"lang" => lang}, socket) do
    update = %{lang: lang}
    Cache.update(socket.assigns.bowl_id, update)

    broadcast! socket, "lang_change", update
    {:noreply, socket}
  end

end
