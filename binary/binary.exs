defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @non_binary ~r([^0^1])
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    if Regex.match?(@non_binary, string), do: 0, else: parse(string)
  end
  
  defp parse(string) do
    String.codepoints(string)
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn digit_tuple -> to_integer(elem(digit_tuple, 0)) * :math.pow(2, elem(digit_tuple, 1)) end)
    |> Enum.reduce(0, fn val, acc -> val + acc end)
    |> round
  end
  
  defp to_integer("1"), do: 1
  defp to_integer("0"), do: 0
end

