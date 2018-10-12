defmodule Memo.BaseCache do
  @moduledoc """
  Agent based cache.
  """

  use Agent

  @behaviour Memo.Behaviour

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @impl true
  def get(key) do
    Agent.get(__MODULE__, fn cache ->
      cache
      |> Map.get(key)
      |> ExMaybe.map(fn val -> {:ok, val} end)
      |> ExMaybe.with_default({:error, "Value not found."})
    end)
  end

  @impl true
  def set(key, value, _ttl) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))

    {:ok, value}
  end
end
