defmodule Memo do
  @moduledoc false

  @spec memoize(module(), atom(), [any()], keyword()) :: any()
  def memoize(module, func, args, opts \\ [])
      when is_atom(module) and is_atom(func) and is_list(args) do
    {cache, _ttl} = parse(opts)
    key = {module, func, args}

    case cache.get(key) do
      {:ok, value} ->
        value

      _ ->
        value = apply(module, func, args)
        cache.set(key, value)
        value
    end
  end

  # Private

  defp parse(opts) do
    cache =
      Keyword.get(opts, :cache, Application.get_env(:memo, :cache)) ||
        raise("Cache must be set!!!")

    ttl = Keyword.get(opts, :ttl, Application.get_env(:memo, :ttl, 3600))

    {cache, ttl}
  end
end
