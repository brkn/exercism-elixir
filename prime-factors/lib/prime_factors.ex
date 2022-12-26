defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []

  def factors_for(number) do
    divider =
      number
      |> range
      |> Enum.find(fn x -> rem(number, x) == 0 end)
      |> case do
        nil -> number
        x -> x
      end

    [divider | number |> div(divider) |> factors_for]
  end

  defp range(number) do
    upperbound = :math.sqrt(number) |> floor |> max(2)

    2..upperbound
  end
end
