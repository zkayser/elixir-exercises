defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: nil, white: nil
  @board_row "_ _ _ _ _ _ _ _"

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  def new() do
    %Queens{white: {0, 3}, black: {7, 3}}
  end
  
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white, black) when white == black, do: raise ArgumentError
  def new(white, black) do
    %Queens{ white: white, black: black }
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    create_board
    |> position(queens.black, queens.white)
    |> Enum.join("\n")
  end
  
  def create_board do
    1..8 
    |> Stream.map(fn _ -> "_ _ _ _ _ _ _ _\n" end)
    |> Enum.join
    |> String.trim_trailing
  end
  
  defp position(empty_board, {b_row, b_col}, {w_row, w_col}) do
    empty_board
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> List.replace_at(b_row, _new_row(b_col * 2, "B"))
    |> List.replace_at(w_row, _new_row(w_col * 2, "W"))
  end
  
  defp _new_row(col, letter) do
    1..8
    |> Stream.map(fn _ -> "_ " end)
    |> Enum.join
    |> String.trim_trailing
    |> String.codepoints
    |> List.replace_at(col, letter)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    cond do
      same_row?(queens.white, queens.black) -> true
      same_column?(queens.white, queens.black) -> true
      on_diagonal?(queens.white, queens.black) -> true
      true -> false
    end
  end
  
  defp same_row?({white, _}, {black, _}), do: white == black
  defp same_column?({_, white}, {_, black}), do: white == black
  defp on_diagonal?({wrow, wcol}, {brow, bcol}), do: abs(wrow - wcol) == abs(brow - bcol)
end