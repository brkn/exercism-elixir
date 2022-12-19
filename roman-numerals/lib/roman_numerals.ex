defmodule RomanNumerals do
  @normal_to_romanic [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(0), do: ""

  def numeral(number) do
    {normal, roman} = @normal_to_romanic |> Enum.find(fn {normal, _} -> number >= normal end)
    roman <> numeral(number - normal)
  end
end
