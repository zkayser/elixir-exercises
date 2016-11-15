defmodule Roman do
  @doc """
  Convert the number to a roman number.
  """
  @digit_mappings %{4 => {"M", nil, nil}, 3 => {"C", "D", "M"}, 2 => {"X", "L", "C"}, 1 => {"I", "V", "X"}}
  @spec numerals(pos_integer) :: String.t
  
  def numerals(0), do: raise ArgumentError
  def numerals(number) when number > 3000, do: raise ArgumentError
  def numerals(number) do
    number
    |> Integer.digits
    |> _construct
  end
  
  defp _construct(digit_list) do
    _construct(digit_list, length(digit_list), "")
  end
  
  defp _construct(_, 0, acc), do: acc
  defp _construct([lead|tail], current_digit, acc) do
    _construct(tail, current_digit - 1, acc <> get_numeral_for(current_digit, lead))
  end
  
  defp get_numeral_for(digit, number) do
    case number do
      0 -> ""
      number when number <= 3 -> String.duplicate(element(digit, 0), number)
      4 -> element(digit, 0) <> element(digit, 1)
      5 -> element(digit, 1)
      number when number <= 8 -> element(digit, 1) <> String.duplicate(element(digit, 0), number - 5)
      9 -> element(digit, 0) <> element(digit, 2)
      _ -> ""
    end
  end
  
  defp element(digit, position) do
    @digit_mappings[digit] |> elem(position)
  end
end
