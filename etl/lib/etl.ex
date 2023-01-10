defmodule ETL do
  @doc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Stream.flat_map(fn {key, characters} ->
      characters
      |> Stream.map(&String.downcase/1)
      |> Stream.map(fn character -> {character, key} end)
    end)
    |> Map.new()
  end
end
