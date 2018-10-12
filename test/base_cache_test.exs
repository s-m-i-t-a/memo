defmodule BaseCacheTest do
  use ExUnit.Case
  use PropCheck
  doctest Memo.BaseCache

  alias Memo.BaseCache

  # Properties

  property "should store and get value from cache" do
    forall [key, val] <- [key(), value()] do
      {:ok, pid} = BaseCache.start_link(nil)

      assert BaseCache.set(key, val, 0) == BaseCache.get(key) and Agent.stop(pid) == :ok
    end
  end

  property "should return error if value not found" do
    forall key <- key() do
      {:ok, pid} = BaseCache.start_link(nil)

      assert BaseCache.get(key) == {:error, "Value not found."} and Agent.stop(pid) == :ok
    end
  end

  # Helpers

  # Generators

  defp key() do
    oneof([
      utf8(),
      atom(),
      number(),
      bool(),
      list(),
      tuple()
    ])
  end

  defp value() do
    oneof([
      utf8(),
      atom(),
      number(),
      bool(),
      list(),
      tuple()
    ])
  end
end
