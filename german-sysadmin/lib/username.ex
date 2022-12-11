defmodule Username do
  @german_chars %{
    "ä" =>	"ae"
    "ö" =>	"oe"
    "ü" =>	"ue"
    "ß" =>	"ss"
  }

  def sanitize(""), do: ""

  def sanitize(username) do
    username |> String.split |> Enum.filter(fn x -> lowercase? x end)
  end

  defp lowercase?(char), do: char != char |> String.upcase()
end

# ä becomes ae
# ö becomes oe
# ü becomes ue
# ß becomes ss

# Please implement the sanitize/1 function
