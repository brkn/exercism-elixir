defmodule WineCellar do
  @colors [
    white: "Fermented without skin contact.",
    red: "Fermented with skin contact using dark-colored grapes.",
    rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
  ]

  def explain_colors, do: @colors

  def filter(cellar, color, opts \\ []) do
    cellar
    |> Keyword.get_values(color)
    |> filter_by_year(Keyword.get(opts, :year))
    |> filter_by_country(Keyword.get(opts, :country))
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)

  defp filter_by_year(wines, nil), do: wines
  defp filter_by_year([], _year), do: []
  defp filter_by_year([{_, year, _} = wine | tail], year), do: [ wine |filter_by_year(tail, year)]
  defp filter_by_year([{_, _, _} | tail], year), do: filter_by_year(tail, year)


  defp filter_by_country(wines, country)
  defp filter_by_country(wines, nil), do: wines
  defp filter_by_country([], _country), do: []
  defp filter_by_country([{_, _, country} = wine | tail], country), do: [wine | filter_by_country(tail, country)]
  defp filter_by_country([{_, _, _} | tail], country), do: filter_by_country(tail, country)
end
