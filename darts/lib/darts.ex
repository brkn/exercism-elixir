defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    pos = :math.sqrt(x*x + y*y)
    cond do
      pos > 10 -> 0
      pos > 5 -> 1
      pos > 1 -> 5
      true -> 10
    end
  end
end
