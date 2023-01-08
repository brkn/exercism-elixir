defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun), do: do_keep(list, fun)

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun), do: do_keep(list, &(not fun.(&1)))

  defp do_keep([], _fun), do: []

  defp do_keep([head | tail], fun) do
    case fun.(head) do
      true -> [head | do_keep(tail, fun)]
      false -> do_keep(tail, fun)
    end
  end
end
