defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num), do: rows(num, [])
  
  defp rows(1, acc), do: acc ++ [[1]] |> Enum.reverse
  defp rows(num, acc) when num > 1 do
    List.last(rows(num - 1))
    |> Enum.chunk(2, 1)
    |> Enum.map(fn pair -> Enum.sum(pair) end)
    |> List.insert_at(0, 1)
    |> List.insert_at(-1, 1)
    |> append(acc, num - 1)
  end
  
  defp append(list, acc, num), do: rows(num, acc ++ [list])
end
