defmodule Memo do
  @moduledoc """
  A memoization library.
  """

  @doc """
  Function memoize return `value` from `module`, `function` and `args`,

  ## Options

  * `:cache` - Cache module implemented `Memo.Behaviour` eg. `Memo.BaseCache`
  * `:ttl` - time to live in seconds

  ## Examples

  Before use `Memo.BaseCache` you must start it with `Memo.BaseCache.start_link/1`.

      iex> Memo.memoize(Kernel, :div, [5, 2], cache: Memo.BaseCache)
      2
  """
  @spec memoize(module(), atom(), [any()], keyword()) :: any()
  def memoize(module, func, args, opts \\ [])
      when is_atom(module) and is_atom(func) and is_list(args) do
    {cache, ttl} = parse(opts)
    key = {module, func, args}

    case cache.get(key) do
      {:ok, value} ->
        value

      _ ->
        value = apply(module, func, args)
        cache.set(key, value, ttl)
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
