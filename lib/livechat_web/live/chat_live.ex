defmodule LivechatWeb.ChatLive do
  use LivechatWeb, :live_view

  def render(assigns) do
    ~L"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(params, session, socket) do
    IO.inspect(params, label: "PARAMS")
    IO.inspect(session, label: "SESSION")
    temperature = 24
    {:ok, assign(socket, :temperature, temperature)}
  end
end
