defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @book_price 8
  @discounts %{
    0 => 0,
    1 => 0,
    2 => 5,
    3 => 10,
    4 => 20,
    5 => 25
  }

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket),
    do:
      basket
      |> greedy_sets
      |> fix_sets
      |> Enum.map(&price_of_set/1)
      |> Enum.sum()

  defp price_of_set(length_of_set) do
    @book_price * length_of_set * (100 - @discounts[length_of_set])
  end

  @spec greedy_sets(basket :: [book]) :: integer
  defp greedy_sets([]), do: [0]

  defp greedy_sets(basket) do
    basket
    |> MapSet.new()
    |> Enum.to_list()
    |> then(fn set ->
      [length(set) | greedy_sets(basket -- set)]
    end)
  end

  defp fix_sets(set_of_books) do
    cond do
      not Enum.member?(set_of_books, 5) -> set_of_books
      not Enum.member?(set_of_books, 3) -> set_of_books
      true -> fix_sets((set_of_books -- [5, 3]) ++ [4, 4])
    end
  end
end
