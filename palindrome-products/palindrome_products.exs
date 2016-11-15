defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    map = Map.new
    list = 
    for max <- max_factor..min_factor,
        min <- min_factor..max_factor,
        max >= min,
        Integer.to_string(min * max) == String.reverse(Integer.to_string(min * max)),
        do: Map.update(map, (min * max), [[min, max]], fn val -> val ++ [min, max] end)
    _generate(list)
  end
  
  defp _generate(list) do
    Enum.reduce(list, %{}, 
      fn m, acc -> 
        Map.merge(m, acc, 
          fn _k, v1, v2 -> 
            [List.flatten(v2), List.flatten(v1)] 
          end) 
      end)
  end
end
