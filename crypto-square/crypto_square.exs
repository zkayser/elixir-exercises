defmodule CryptoSquare do

  @regex ~r(\W+)
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  
  @spec encode(String.t) :: String.t
  def encode(""), do: ""
  def encode(str) do
    normalized = str |> normalize
    sqrt = normalized |> String.length |> :math.sqrt 
    rows = sqrt |> Float.floor |> round
    cols = sqrt |> Float.ceil |> round
    spaces = (rows * cols) - String.length(normalized)
    normalized <> String.duplicate(" ", spaces)
    |> String.codepoints
    |> _encode(cols, "", 0)
    |> String.replace("  ", " ")
    |> String.trim
  end
  
  defp normalize(str) do
    str
    |> String.downcase
    |> String.replace(@regex, "")
  end
  
  defp _encode([], _, acc), do: acc
  defp _encode(list, cols, acc, dropped) when dropped < cols do
    new = row(list, cols)
    _encode(Enum.drop(list, 1), cols, acc <> new <> " ", dropped + 1)
  end
  defp _encode(_, _, acc, _), do: acc
  
  defp row(list, cols) do
    Enum.take_every(list, cols)
    |> Enum.join
  end
end
