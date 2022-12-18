defmodule FileSniffer do
  @extension_map %{
    "exe" => "application/octet-stream",
    "bmp" => "image/bmp",
    "png" => "image/png",
    "jpg" => "image/jpg",
    "gif" => "image/gif"
  }

  def type_from_extension(extension), do: @extension_map[extension]

  def type_from_binary(file_binary) do
    case file_binary do
      <<0x7F, 0x45, 0x4C, 0x46, _rest::binary>> -> "application/octet-stream"
      <<0x42, 0x4D, _rest::binary>> -> "image/bmp"
      <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _rest::binary>> -> "image/png"
      <<0xFF, 0xD8, 0xFF, _rest::binary>> -> "image/jpg"
      <<0x47, 0x49, 0x46, _rest::binary>> -> "image/gif"
      _ -> nil
    end
  end

  def verify(file_binary, extension) do
    binary_type = type_from_binary(file_binary)
    extension_type = type_from_extension extension

    case binary_type do
      ^extension_type -> {:ok, binary_type}
      _ -> {:error, "Warning, file format and file extension do not match."}
    end
  end
end
