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
    limit = trunc(:math.sqrt(number)) + 1
    head =
      2..limit
      |> Enum.find(fn x -> rem(number, x) == 0 end)

    divider = if is_nil(head), do: number, else: head

    remaining = div(number, divider)

    [divider | factors_for(remaining)]
  end
end
