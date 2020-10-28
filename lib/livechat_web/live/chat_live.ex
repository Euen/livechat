defmodule LivechatWeb.ChatLive do
  use LivechatWeb, :live_view
  # use Phoenix.HTML
  # import LivechatWeb.ErrorHelpers

  # def render(assigns) do
  #   ~L"""
  #   Current temperature: <%= @temperature %>
  #   """
  # end

  # def mount(params, session, socket) do
  #   IO.inspect(params, label: "PARAMS")
  #   IO.inspect(session, label: "SESSION")
  #   temperature = 24
  #   {:ok, assign(socket, :temperature, temperature)}
  # end

  alias Livechat.Chat
  alias Livechat.Chat.Message

  def mount(_params, _session, socket) do
    if connected?(socket), do: Chat.subscribe()
    {:ok, fetch(socket)}
  end

  def render(assigns) do
    LivechatWeb.ChatView.render("index.html", assigns)
  end

  def handle_event("validate", %{"message" => params}, socket) do
    changeset =
      %Message{}
      |> Chat.change_message(params)
      |> Map.put(:action, :insert)

      {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("send_message", %{"message" => params}, socket) do
    case Chat.create_message(params) do
      {:ok, message} ->
        {:noreply, fetch(socket, message.username)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info({Chat, [:message, event_type], message}, socket) do
    IO.inspect(event_type, label: "event_type")
    IO.inspect(message, label: "message")
    {:noreply, fetch(socket, get_username(socket))}
  end

  def fetch(socket, username \\ nil) do
    assign(socket, %{
      username: username,
      messages: Chat.list_messages(),
      changeset: Chat.change_message(%Message{username: username})
    })
  end

  defp get_username(socket) do
    socket.assigns
    |> Map.get(:username)
  end
end
