defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    path
      |> String.split(".")
      |> Enum.reduce(data, fn elem, acc -> if Kernel.is_nil(acc), do: nil, else: Map.get(acc, elem) end)
  end

  def get_in_path(data, path), do: data |> Kernel.get_in(String.split(path, "."))
end
