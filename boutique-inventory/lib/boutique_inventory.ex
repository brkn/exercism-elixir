defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(& &1.price)

  def with_missing_price(inventory), do: inventory |> Enum.filter(&is_nil(&1.price))

  def update_names(inventory, old_word, new_word),
    do: inventory |> Enum.map(&replace_item_name(&1, old_word, new_word))

  def increase_quantity(item, count) do
    new_quantities = item.quantity_by_size |> Enum.into(%{}, fn {k, v} -> {k, v + count} end)

    Map.merge(item, %{quantity_by_size: new_quantities})
  end

  def total_quantity(item),
    do:
      item.quantity_by_size
      |> Map.values()
      |> Enum.reduce(0, &+/2)

  defp replace_name(name, old_word, new_word), do: name |> String.replace(old_word, new_word)

  defp replace_item_name(item, old_word, new_word),
    do: item |> Map.merge(%{name: replace_name(item.name, old_word, new_word)})
end
