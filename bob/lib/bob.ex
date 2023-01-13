defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input
    |> String.trim()
    |> then(fn trimmed -> {empty?(trimmed), all_capital?(trimmed), question?(trimmed)} end)
    |> case do
      {true, _, _} -> "Fine. Be that way!"
      {_, true, true} -> "Calm down, I know what I'm doing!"
      {_, true, false} -> "Whoa, chill out!"
      {_, false, true} -> "Sure."
      {_, false, false} -> "Whatever."
    end
  end

  defp all_capital?(input),
    do:
      input
      |> String.split("")
      |> Enum.filter(fn char -> Regex.match?(~r/[\p{L}]/, char) end)
      |> then(fn chars ->
        !Enum.empty?(chars) and Enum.all?(chars, fn char -> char == String.upcase(char) end)
      end)

  defp question?(input), do: String.last(input) == "?"

  defp empty?(input), do: input == ""
end
