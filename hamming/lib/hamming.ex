defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2),
    do: {:error, "strands must be of equal length"}

  def hamming_distance([], []), do: {:ok, 0}

  def hamming_distance([head1 | tail1], [head2 | tail2]) do
    {_, accum} = hamming_distance(tail1, tail2)
    case head1 == head2 do
      true -> {:ok, accum}
      false -> {:ok, 1 + accum}
    end
  end
end
