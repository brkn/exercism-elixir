defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand), do: do_sqrt radicand

  defp do_sqrt(radicand, guess \\ 1)
  defp do_sqrt(radicand, guess) when guess * guess == radicand, do: guess
  defp do_sqrt(radicand, guess), do: do_sqrt(radicand, guess + 1)
end
