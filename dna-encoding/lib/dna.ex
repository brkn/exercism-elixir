defmodule DNA do
  @nucleotides %{
    ?A => 0b0001,
    ?C => 0b0010,
    ?G => 0b0100,
    ?T => 0b1000,
    ?\s => 0b0000
  }
  @reverse_nucleotides Enum.map(@nucleotides, fn {k,v} -> {v,k} end) |> Map.new
  def encode_nucleotide(code_point), do: @nucleotides[code_point]
  def decode_nucleotide(encoded_code), do: @reverse_nucleotides[encoded_code]
  def encode(dna) do
    dna
    |> Enum.map(&encode_nucleotide/1)
    |> Enum.map(fn v -> <<v::4>> end)
    |> Enum.reduce(fn elem, acc -> <<acc::bitstring, elem::bitstring>> end)
  end
  def decode(dna, decoded \\ [])
  def decode(<<first::4>>, decoded), do: Enum.concat decoded, [decode_nucleotide(first)]
  def decode(<<first::4, rest::bitstring>>, decoded), do: decode(rest, decoded |> Enum.concat [decode_nucleotide(first)])
end
