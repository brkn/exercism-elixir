defmodule ResistorColorTrio do
  @code_mapping %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms}
  def label(colors) do
    [first, second, zeroes] = colors |> Enum.map(&@code_mapping[&1])

    ohms = Integer.undigits [first, second | List.duplicate(0, zeroes)]

    if rem(ohms, 1000) != 0 do
      {ohms, :ohms}
    else
      {ohms / 1000, :kiloohms}
    end
  end
end
