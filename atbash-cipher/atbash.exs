defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @regex ~r(\W)
  @char_map %{
    "a" => "z", "b" => "y", "c" => "x", "d" => "w", "e" => "v",
    "f" => "u", "g" => "t", "h" => "s", "i" => "r", "j" => "q",
    "k" => "p", "l" => "o", "m" => "n", "n" => "m", "o" => "l",
    "p" => "k", "q" => "j", "r" => "i", "s" => "h", "t" => "g",
    "u" => "f", "v" => "e", "w" => "d", "x" => "c", "y" => "b",
    "z" => "a"
  }
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext
    |> String.downcase
    |> String.replace(@regex, "")
    |> String.codepoints
    |> Enum.map(&_encode/1)
    |> Enum.chunk(5, 5, [])
    |> Enum.join(" ")
  end
  
  defp _encode(char) do
    keys = Map.keys(@char_map)
    if char in keys, do: Map.get(@char_map, char), else: char
  end
end
