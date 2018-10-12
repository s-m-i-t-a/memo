defmodule MemoTest do
  use ExUnit.Case
  use PropCheck
  doctest Memo

  alias Memo.BaseCache

  defmodule Test do
    def function(val) do
      send(self(), val)

      val
    end
  end

  setup do
    {:ok, _pid} = BaseCache.start_link(nil)

    :ok
  end

  # Tests

  test "should first call evaluate supplied function" do
    val = Memo.memoize(Test, :function, ["foo"], cache: BaseCache)

    assert_received ^val
  end

  # Properties

  property "should second call return value from cache" do
    forall call_count <- pos_integer() do
      for _ <- 1..call_count do
        "bar" = Memo.memoize(Test, :function, ["bar"], cache: BaseCache)
      end

      assert Process.info(self(), :message_queue_len) == {:message_queue_len, 1}
    end
  end

  # Helpers

  # Generators
end
