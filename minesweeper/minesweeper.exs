defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]
  def annotate([]), do: []
  def annotate(board) do
    cond do
      blank?(board) -> board
      full?(board) -> board
      true -> 
        board
        |> Enum.map(&String.codepoints/1)
        |> Enum.with_index
        |> into_map
        |> process
        |> join
    end
  end
  
  defp blank?(board) do
    Enum.all?(board, fn str -> not Regex.match?(~r(\*), str) end)
  end
  
  defp full?(board) do
    Enum.all?(board, fn str -> not Regex.match?(~r([^\*]), str) end)
  end
  
  defp into_map(list) when is_list(list) do
    for tuple <- list, into: %{}, do: {elem(tuple, 1), elem(tuple, 0)}
  end
  
  defp process(map) do
    rows = length(Map.keys(map))
    columns = Map.get(map, 0) |> Kernel.length
    _process(map, 0, 0, rows - 1, columns - 1)
  end
  
  defp _process(map, row, col, rows, columns) when row <= rows and col < columns do
    case Map.get(map, row) |> Enum.at(col) do
      "*" -> _process(map, row, col + 1, rows, columns)
      " " -> mines_surrounding(map, row, col, rows) |> _process(row, col + 1, rows, columns)
      _ -> map
    end
  end
  
  defp _process(map, row, col, rows, columns) when row <= rows and col == columns do
    case Map.get(map, row) |> Enum.at(col) do
      "*" -> _process(map, row + 1, 0, rows, columns)
      " " -> mines_surrounding(map, row, col, rows) |> _process(row + 1, 0, rows, columns)
      _ -> map
    end
  end
  
  defp _process(map, _, _, _, _), do: map
  
  defp mines_surrounding(map, row, col, rows) do
    same_row = [get_value(map, row, col - 1, rows), get_value(map, row, col + 1, rows)]
    above = [get_value(map, row - 1, col, rows), get_value(map, row - 1, col - 1, rows), get_value(map, row - 1, col + 1, rows)]
    below = [get_value(map, row + 1, col, rows), get_value(map, row + 1, col - 1, rows), get_value(map, row + 1, col + 1, rows)]
    same_row ++ above ++ below |> count(map, row, col)
  end
  
  defp count(list, map, row, col) do
    c = Enum.filter(list, fn x -> x == "*" end)
    |> Enum.count
    update = List.replace_at(Map.get(map, row), col, c)
    Map.put(map, row, update)
  end
  
  defp get_value(_, row, _, rows) when row > rows, do: nil
  defp get_value(map, row, col, _) when row >= 0 and col >= 0 do
    Map.get(map, row) |> Enum.at(col)
  end
  defp get_value(_, _, _, _), do: nil
  
  defp join(map) do
    Map.values(map)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.replace(&1, "0", " "))
  end
end
