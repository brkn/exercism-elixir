defmodule Username do
  def sanitize(''), do: ''

  def sanitize(username) do
    username
    |> Enum.flat_map(&subsitute_german_chars/1)
    |> Enum.filter(fn char -> lowercase?(char) or char == ?_ end)
  end

  defp lowercase?(char), do: char >= ?a and char <= ?z

  defp subsitute_german_chars(char) do
    case char do
      ?ä -> 'ae'
      ?ö -> 'oe'
      ?ü -> 'ue'
      ?ß -> 'ss'
      _ -> [char]
    end
  end
end
