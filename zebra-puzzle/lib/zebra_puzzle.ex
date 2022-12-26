defmodule ZebraPuzzle do
  @colors ["red", "green", "ivory", "yellow", "blue"]
  @nations ["englishman", "spaniard", "ukrainian", "norwegian", "japanese"]
  @pets ["dog", "fox", "horse", "snails", "zebra"]
  @drinks ["coffee", "tea", "milk", "orange juice", "water"]
  @smokes ["chesterfields", "kools", "lucky strike", "old gold", "parliaments"]

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    comb2
    # all_house_combinations() # There are five houses.
    # |> reject_houses_not_matching(%{nation: "englishman", color: "red"}) # The Englishman lives in the red house.
    # |> reject_houses_not_matching(%{nation: "spaniard", pet: "dog"}) # The Spaniard owns the dog.
    # |> reject_houses_not_matching(%{drink: "coffee", color: "green"}) # Coffee is drunk in the green house.
    # |> reject_houses_not_matching(%{nation: "ukrainian", drink: "tea"}) # The Ukrainian drinks tea.
    # |> reject_houses_not_matching(%{smoke: "old gold", pet: "snails"}) # The Old Gold smoker owns snails.
    # |> reject_houses_not_matching(%{smoke: "kools", color: "yellow"}) # Kools are smoked in the yellow house.
    # |> reject_houses_not_matching(%{drink: "milk", order: 3})# Milk is drunk in the middle house.
    # |> reject_houses_not_matching(%{nation: "norwegian", order: 1}) # The Norwegian lives in the first house.
    # |> reject_houses_not_matching(%{nation: "lucky strike", drink: "orange juice"}) # The Lucky Strike smoker drinks orange juice.
    # |> reject_houses_not_matching(%{nation: "japanese", smoke: "parliaments"}) # The Japanese smokes Parliaments.

    # |> reject_by_order_constraints


    # |> Enum.map(& &1[:order])
    # |> Enum.frequencies()
    # |> Enum.uniq
    # |> length
  end


  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
  end

  def all_house_combinations() do
    @colors
    |> Enum.flat_map(fn color ->
      @nations |> Enum.flat_map(fn nation ->
        @pets |> Enum.flat_map(fn pet ->
          @drinks |> Enum.flat_map(fn drink ->
            @smokes |> Enum.flat_map(fn smoke ->
              1..5 |> Enum.map(fn order ->
                %{
                  order: order,
                  color: color,
                  nation: nation,
                  pet: pet,
                  drink: drink,
                  smoke: smoke
                }
              end)
            end)
          end)
        end)
      end)
    end)
  end

  def comb2 do
    # permutations(@colors) |> Stream.map(fn color_permutation ->
    #   permutations(@nations) |> Stream.map(fn nation_permutation ->
    #     permutations(@pets) |> Stream.map(fn pet_permutation ->
    #       permutations(@drinks) |> Stream.map(fn drink_permutation ->
    #         permutations(@smokes) |> Stream.map(fn smoke_permutation ->
    #           IO.inspect([
    #             color_permutation,
    #             nation_permutation,
    #             pet_permutation,
    #             drink_permutation,
    #             smoke_permutation
    #           ])
    #           end)
    #         end)
    #       end)
    #     end)
    #   end) |> Enum.take(5)
    List.zip(
      [
        permutations(@colors),
        permutations(@nations),
        permutations(@pets),
        permutations(@drinks),
        permutations(@smokes)
      ]
    )
  end

  def reject_houses_not_matching(houses, hash_to_match) do
    houses
    |> Enum.reject(fn house -> house_inconsistently_matching?(house, hash_to_match) end)
  end

  def reject_houses_not_matching(houses, first_house_to_match, second_house_to_match, compare_func) do
    first_house_possibilities = houses |> Enum.filter(fn house ->
      house_matching?(house, first_house_to_match)
    end)
    second_house_possibilities = houses |> Enum.filter(fn house ->
      house_matching?(house, second_house_to_match)
    end)
    IO.inspect(length houses)

    first_houses_to_reject = first_house_possibilities |> Enum.reject(fn first_house_possibility ->
      second_house_possibilities |> Enum.any?(fn second_house_possibility ->
        compare_func.(first_house_possibility, second_house_possibility)
      end)
    end)
    second_houses_to_reject = second_house_possibilities |> Enum.reject(fn second_house_possibility ->
      first_house_possibilities |> Enum.any?(fn first_house_possibility ->
        compare_func.(first_house_possibility, second_house_possibility)
      end)
    end)

    (houses -- first_houses_to_reject) -- second_houses_to_reject
  end

  def house_matching?(house, hash_to_match) do
    hash_to_match
    |> Enum.all?(fn({key, val}) -> Map.get(house, key) == val end)
  end

  def house_inconsistently_matching?(house, hash_to_match) do
    hash_to_match
    |> Enum.map(fn({key, val}) ->
      case Map.get(house, key) do
        ^val -> 1
        _ -> 0
      end
    end)
    |> Enum.sum()
    |> case do
      1 -> true
      _ -> false
    end
  end

  def reject_by_order_constraints(houses, prev_length \\ 0)
  def reject_by_order_constraints(houses, prev_length) when length(houses) == prev_length, do: houses
  def reject_by_order_constraints(houses, prev_length) do
  filtered_houses = houses
    |> reject_houses_not_matching(%{color: "green"}, %{color: "ivory"}, fn first_house, second_house ->
      first_house[:order] == second_house[:order] + 1
    end) # The green house is immediately to the right of the ivory house.
    |> reject_houses_not_matching(%{smoke: "chesterfields"}, %{pet: "fox"}, fn first_house, second_house ->
      [first_house[:order] + 1, first_house[:order] -1] |> Enum.member?(second_house[:order])
    end) # The man who smokes Chesterfields lives in the house next to the man with the fox.
    |> reject_houses_not_matching(%{smoke: "kools"}, %{pet: "horse"}, fn first_house, second_house ->
      [first_house[:order] + 1, first_house[:order] -1] |> Enum.member?(second_house[:order])
    end)# Kools are smoked in the house next to the house where the horse is kept.
    |> reject_houses_not_matching(%{nation: "norwegian"}, %{color: "blue"}, fn first_house, second_house ->
      [first_house[:order] + 1, first_house[:order] -1] |> Enum.member?(second_house[:order])
    end)# The Norwegian lives next to the blue house.

    reject_by_order_constraints(filtered_houses, length(houses))
  end

  # def filter_combinations(combinations, house_to_match) do
  #   combinations |>
  #   Enum.filter(fn house_array ->
  #     house_array
  #     |> Enum.any?(fn house ->
  #       # match? %{color: "red", nation: "englishman"}, house
  #       match? ^house_to_match, house
  #     end)
  #   end)
  # end\

  def permutations([]), do: [[]]

  def permutations(list) do
    for item <- list, tail <- permutations(list -- [item]), do: [item | tail]
  end
end
