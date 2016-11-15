defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer
  def largest_product(_, 0), do: 1
  def largest_product("", _), do: raise ArgumentError
  def largest_product(_, size) when size < 0, do: raise ArgumentError
  def largest_product(string, size) when size > byte_size(string), do: raise ArgumentError
  def largest_product(number_string, size) do
    number_string
    |> String.codepoints
    |> Enum.map(fn str -> String.to_integer(str) end)
    |> Enum.chunk(size, 1)
    |> Enum.map(
      fn chunk -> 
        Enum.reduce(chunk, 1, fn val, acc -> val * acc end)
      end)
    |> Enum.max
  end
end
