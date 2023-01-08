defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: _b}, _message)
      when rem(a, 2) == 0
      when rem(a, 13) == 0,
      do: {:error, "a and m must be coprime."}

  def encode(%{a: a, b: b}, message) do
    {
      :ok,
      message
      |> String.replace([" ", ".", ","], "")
      |> String.split("", trim: true)
      |> Enum.map(&String.downcase/1)
      |> Enum.map(fn char -> encode_char(char, %{a: a, b: b}) end)
      |> Enum.chunk_every(5)
      |> Enum.map(&List.to_string/1)
      |> Enum.join(" ")
    }
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    with {:ok, mmi} <- to_mmi(a) do
      {
        :ok,
        encrypted
        |> String.replace(" ", "")
        |> String.split("", trim: true)
        |> Enum.map(fn char -> decode_char(char, %{mmi: mmi, b: b}) end)
        |> List.to_string()
      }
    else
      err -> err
    end
  end

  @spec encode_char(char :: String.t(), key :: key()) :: String.t()
  defp encode_char(<<charpoint>> = char, %{a: a, b: b}) do
    case Integer.parse(char) do
      :error -> Integer.mod(a * (charpoint - ?a) + b, 26) + ?a
      _ -> charpoint
    end
  end

  defp decode_char(<<charpoint>> = char, %{mmi: mmi, b: b}) do
    case Integer.parse(char) do
      :error -> Integer.mod(mmi * (charpoint - ?a - b), 26) + ?a
      _ -> charpoint
    end
  end

  defp to_mmi(a, possible_mmi \\ 1)

  defp to_mmi(_a, possible_mmi) when possible_mmi == 26, do: {:error, "a and m must be coprime."}

  defp to_mmi(a, possible_mmi) do
    cond do
      Integer.mod(a * possible_mmi, 26) == 1 -> {:ok, possible_mmi}
      true -> to_mmi(a, possible_mmi + 1)
    end
  end
end
