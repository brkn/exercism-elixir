defmodule FoodChain do
  @prefix "I know an old lady who swallowed a"
  @chain [
    "fly",
    "spider",
    "bird",
    "cat",
    "dog",
    "goat",
    "cow",
    "horse"
  ]

  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    (start - 1)..(stop - 1)
    |> Enum.flat_map(&verse/1)
    |> Enum.join("\n")
  end

  defp verse(index), do: [i_know_a_lady(index) | tail(index)]

  defp i_know_a_lady(index) do
    case thing(index) do
      "fly" -> "#{@prefix} fly."
      "spider" -> "#{@prefix} spider.\nIt wriggled and jiggled and tickled inside her."
      "bird" -> "#{@prefix} bird.\nHow absurd to swallow a bird!"
      "cat" -> "#{@prefix} cat.\nImagine that, to swallow a cat!"
      "dog" -> "#{@prefix} dog.\nWhat a hog, to swallow a dog!"
      "goat" -> "#{@prefix} goat.\nJust opened her throat and swallowed a goat!"
      "cow" -> "#{@prefix} cow.\nI don't know how she swallowed a cow!"
      "horse" -> "#{@prefix} horse.\nShe's dead, of course!\n"
    end
  end

  defp tail(7), do: []
  defp tail(index), do: index..0 |> Enum.map(&she_swallowed/1)

  defp she_swallowed(0), do: "I don't know why she swallowed the fly. Perhaps she'll die.\n"
  defp she_swallowed(2),
    do:
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her."
  defp she_swallowed(index), do: "She swallowed the #{thing(index)} to catch the #{thing(index - 1)}."

  defp thing(index), do: @chain |> Enum.at(index)
end
