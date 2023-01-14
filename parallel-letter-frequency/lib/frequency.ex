defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers),
    do:
      texts
      |> Stream.flat_map(fn text ->
        text
        |> Stream.unfold(fn
          "" -> nil
          str -> String.split_at(str, chunk_count(text, workers))
        end)
      end)
      |> Task.async_stream(&asd/1, max_concurrency: workers)
      |> Enum.reduce(%{}, fn {:ok, freq}, acc ->
        Map.merge(freq, acc, fn _k, v1, v2 -> v1 + v2 end)
      end)

  defp chunk_count(text, workers),
    do: text |> String.length() |> Integer.floor_div(workers) |> max(1)

  defp asd(text),
    do:
      text
      |> String.codepoints()
      |> Stream.filter(& Regex.match?(~r/[\p{L}]/u, &1))
      |> Stream.map(&String.downcase/1)
      |> Enum.frequencies()
end
