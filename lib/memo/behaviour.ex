defmodule Memo.Behaviour do
  @moduledoc """
  Define cache behaviour.
  """

  @doc """
  Get value by `key` from cache.
  """
  @callback get(any()) :: any()

  @doc """
  Set `value` with `key` and `ttl` to cache.
  """
  @callback set(any(), any(), non_neg_integer()) :: Result.t(String.t(), any())
end
