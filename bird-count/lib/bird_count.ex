defmodule BirdCount do
  def today([]), do: nil
  def today([head | _]), do: head

  def increment_day_count([]), do: [1]
  def increment_day_count([head | tail]), do: [head + 1 | tail]

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([head | _]) when head == 0, do: true
  def has_day_without_birds?([_ | tail]), do: has_day_without_birds?(tail)

  def total(list), do: total(list, 0)
  defp total([], x), do: x
  defp total([head | tail], x), do: total(tail, x + head)

  def busy_days(list), do: busy_days(list, 0)
  defp busy_days([head | tail], x) when head >= 5, do: busy_days(tail, x + 1)
  defp busy_days([_ | tail], x), do: busy_days(tail, x)
  defp busy_days([], x), do: x
end
