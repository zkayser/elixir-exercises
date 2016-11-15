defmodule Connect do

  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t]) :: :none | :black | :white
  def result_for(board) do
    goal = (board |> Enum.at(0) |> String.length) - 1
    cond do
      board |> pieces_for("X") |> winner?(goal) -> :black
      board |> pieces_for("O") |> winner?(goal) -> :white
      true -> :none
    end
  end

  defp pieces_for(board, player) do
    board
    |> transpose(player)
    |> build_board
    |> Enum.filter(fn {_, _, v} -> v == player end)
    |> Enum.map(fn {x, y, _} -> {x, y} end)
  end

  defp transpose(board, player) do
    cond do
      player == "O" -> board
      true ->
        board
        |> Enum.map(&String.codepoints/1)
        |> List.zip
        |> Enum.map(&Enum.join(Tuple.to_list(&1)))
    end
  end

  defp build_board(board) do
    size = Enum.count(board) - 1
    for x <- 0..size,
        y <- 0..size,
        v = board |> Enum.at(x) |> String.at(y),
        do: {x, y, v}
  end

  defp winner?([], _), do: false
  defp winner?(pieces, goal) do
    pieces
    |> Enum.filter(fn {x, _} -> x == 0 end)
    |> Enum.any?(&(adjacent?(&1, pieces, goal)))
  end

  defp adjacent?(cell={x, _}, pieces, goal) do
    next = get_adjacents(cell, pieces)
    cond do
      goal == x           -> true
      Enum.count(next) == 0 -> false
      true                  ->
        Enum.any?(next, &(adjacent?(&1, List.delete(pieces, cell), goal)))
    end
  end

  defp get_adjacents({x, y}, pieces) do
    adjacent_coords = [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
    Enum.filter(pieces, &(&1 in adjacent_coords))
  end
end