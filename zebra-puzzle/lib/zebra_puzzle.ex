defmodule ZebraPuzzle do
  @house_template %{
    color: :unknown,
    nation: :unknown,
    pet: :unknown,
    drink: :unknown,
    smoke: :unknown
  }

  @colors ["red", "green", "ivory", "yellow", "blue"]
  @nationalities ["englishman", "spaniard", "ukrainian", "norwegian", "japanese"]
  @pets ["dog", "fox", "horse", "snails", "zebra"]
  @beverages ["coffee", "tea", "milk", "orange juice", "water"]
  @smokes ["chesterfields", "kools", "lucky strike", "old gold", "parliaments"]

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    all_house_combinations()
    |> reject_houses_not_matching(%{nation: "englishman", color: "red"}) # The Englishman lives in the red house.
    # |> reject_houses_not_matching(%{nation: "spaniard", pet: "dog"}) # The Spaniard owns the dog.
    # |> Enum.map(& &1.nation)
    # |> Enum.uniq
    |> length
    # |> reject_houses_not_matching(%{beverage: "coffee", color: "green"}) # Coffee is drunk in the green house.
    # |> reject_houses_not_matching(%{nation: "ukrainian", beverage: "tea"}) # The Ukrainian drinks tea.
    # |> reject_houses_not_matching(%{smoke: "old gold", pet: "snails"}) # The Old Gold smoker owns snails.
    # |> reject_houses_not_matching(%{smoke: "kools", color: "yellow"}) # Kools are smoked in the yellow house.
    # |> reject_houses_not_matching(%{beverage: "milk", order: 3})# Milk is drunk in the middle house.
    # |> reject_houses_not_matching(%{nation: "norwegian", order: 1}) # The Norwegian lives in the first house.
    # |> reject_houses_not_matching(%{nation: "lucky strike", beverage: "orange juice"}) # The Lucky Strike smoker drinks orange juice.
    # |> reject_houses_not_matching(%{nation: "japanese", smoke: "parliaments"}) # The Japanese smokes Parliaments.
  end


  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
  end

  defp all_house_combinations() do
    house_combination_set =
      for color <- @colors,
          nation <- @nationalities,
          pet <- @pets,
          beverage <- @beverages,
          smoke <- @smokes,
          order <- 1..5
          do
            %{
            order: order,
            color: color,
            nation: nation,
            pet: pet,
            beverage: beverage,
            smoke: smoke
          }
        end
  end

  defp reject_houses_not_matching(houses, hash_to_match) do
    houses
    |> Enum.reject(fn house -> house_not_matching?(house, hash_to_match) end)
  end

  defp house_not_matching?(house, hash_to_match) do
    hash_to_match
    |> Enum.map(fn({key, val}) ->
      case Map.get(house, key) do
        val -> 1
        _ -> 0
      end
    end)
    |> Enum.sum()
    |> case do
      1 -> true
      _ -> false
    end
  end

  # defp filter_combinations(combinations, house_to_match) do
  #   combinations |>
  #   Enum.filter(fn house_array ->
  #     house_array
  #     |> Enum.any?(fn house ->
  #       # match? %{color: "red", nation: "englishman"}, house
  #       match? ^house_to_match, house
  #     end)
  #   end)
  # end
end
