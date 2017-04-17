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
    bowl = case Cache.fetch(socket.assigns.bowl_id) do
      {:ok, result} -> result
      {:error, _} -> Cache.save(socket.assigns.bowl_id, Bowl.default)
    end

    push socket, "editor_set", bowl
    {:noreply, socket}
  end

  def handle_in("editor_change", %{"body" => body, "row" => row, "column" => column}, socket) do
    bowl = %{body: body, row: row, column: column}
    Cache.update(socket.assigns.bowl_id, bowl)
    broadcast! socket, "editor_change", bowl
    {:noreply, socket}
  end

  def handle_in("lang_change", %{"lang" => lang}, socket) do
    broadcast! socket, "lang_change", %{lang: lang}
    {:noreply, socket}
  end

end
