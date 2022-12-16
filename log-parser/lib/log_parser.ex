defmodule LogParser do
  @validity_regex ~r/^\[(DEBUG)|(INFO)|(WARNING)|(ERROR)\]/
  @split_regex ~r/<[\~\*\=\-]*>/
  @garbage_regex ~r/(end-of-line)\d+/i
  @username_regex ~r/(User)[\s\t]+([^\s]+)/u

  def valid_line?(line), do: String.match? line, @validity_regex

  def split_line(line), do: Regex.split(@split_regex, line)

  def remove_artifacts(line), do: Regex.replace(@garbage_regex, line, "")

  def tag_with_user_name(line) do
    username = @username_regex
      |> Regex.run(line)
      |> case do
        nil -> nil
        capture_group -> Enum.at(capture_group, 2)
      end

    case username do
      nil -> line
      _ -> "[USER] #{username} #{line}"
    end
  end
end
