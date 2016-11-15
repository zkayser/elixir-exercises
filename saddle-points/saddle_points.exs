defmodule Matrix do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Stream.map(fn str -> String.split(str, " ") end)
    |> Enum.map(fn str_array -> parse_integers(str_array) end)
  end
  
  defp parse_integers(str_array) do
    Enum.map(str_array, fn str -> String.to_integer(str) end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows
    |> rows_to_columns
  end
  
  defp rows_to_columns(rows) do
    count = Enum.at(rows, 0) |> Enum.count
    0..(count - 1)
    |> Enum.map(fn index -> _rows_to_columns(rows, index) end)
  end
  
  defp _rows_to_columns(rows, index) do
    for row <- rows, into: [], do: Enum.at(row, index)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    cols = columns(str) |> col_mins |> List.flatten
    rows(str)
    |> row_maxes
    |> List.flatten
    |> Enum.filter(fn elem -> match_col_mins?(elem, cols) end)
    |> Enum.map(fn {_, _, {r, c}} -> {r, c} end)
  end
  
  defp row_maxes(rows) do
    count = Enum.count(rows)
    for index <- 0..(count - 1) do
      row = Enum.at(rows, index)
      Enum.with_index(row)
      |> Stream.filter(fn {elem, _} -> elem == Enum.max(row) end)
      |> Enum.map(fn {val, col} -> {:max, val, {index, col}} end)
    end
  end
  
  defp col_mins(cols) do
    count = Enum.count(cols)
    for index <- 0..(count - 1) do
      col = Enum.at(cols, index)
      Enum.with_index(col)
      |> Stream.filter(fn {elem, _} -> elem == Enum.min(col) end)
      |> Enum.map(fn {val, row} -> {:min, val, {row, index}} end)
    end
  end
  
  defp match_col_mins?({:max, value, {row, col}}, cols) do
    Enum.any?(cols, fn {:min, _, {r, c}} -> {row, col} == {r, c} end)
  end
end
