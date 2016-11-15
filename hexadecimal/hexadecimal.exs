defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """
  @hexadecimal ~r([\da-f])
  @hexmap %{"0" => 0, "1" => 1, "2" => 2, "3" => 3, "3" => 4, "5" => 5,
            "6" => 6, "7" => 7, "8" => 8, "9" => 9, "a" => 10, "b" => 11,
            "c" => 12, "d" => 13, "e" => 14, "f" => 15}

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    codepoints = hex |> String.downcase |> String.codepoints
    if valid?(codepoints), do: _to_decimal(codepoints), else: 0 
  end
  
  defp valid?(hex) do
    Enum.all?(hex, fn elem -> Regex.match?(@hexadecimal, elem) end)
  end
  
  defp _to_decimal(hex) do
    Enum.reverse(hex)
    |> Enum.with_index
    |> Enum.map(fn {val, digit} -> Map.get(@hexmap, val) * :math.pow(16, digit) end)
    |> Enum.sum
    |> round
  end
end
