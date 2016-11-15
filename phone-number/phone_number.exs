defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "3035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @accept ~w(1 2 3 4 5 6 7 8 9 0 a b c d e f g h i j k l m n o p q r s t u v w x y z)
  @spec number(String.t) :: String.t
  def number(raw) do
    raw |> String.codepoints |> Enum.filter(&(&1 in @accept)) |> Enum.join |> do_number
  end
  
  defp do_number(number) when byte_size(number) == 10, do: number
  defp do_number(<<"1", rest::binary>>) when byte_size(rest) == 10, do: rest
  defp do_number(_), do: "0000000000"
  

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    number(raw) |> _area_code
  end
  
  defp _area_code(<<digit1::binary-size(1), digit2::binary-size(1), digit3::binary-size(1), rest::binary>>) do
    digit1 <> digit2 <> digit3
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    number(raw) |> _pretty
  end
  
  defp _pretty(<<a_code::binary-size(3), exchange::binary-size(3), subscriber::binary>>) do
    "(#{a_code})" <> " " <> exchange <> "-" <> subscriber
  end
end
