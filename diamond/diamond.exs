defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @char_map %{
    ?A => "A", ?B => "B", ?C => "C", ?D => "D", ?E => "E", ?F => "F", ?G => "G",
    ?H => "H", ?I => "I", ?J => "J", ?K => "K", ?L => "L", ?M => "M", ?N => "N",
    ?O => "O", ?P => "P", ?Q => "R", ?S => "S", ?T => "T", ?U => "U", ?V => "V",
    ?W => "W", ?X => "X", ?Y => "Y", ?Z => "Z"
  }
  @spec build_shape(char) :: String.t
  def build_shape(letter) do
    keys = Map.keys(@char_map) 
    index = Enum.find_index(keys, fn char -> char == letter end)
    Enum.take(keys, index + 1) |> _build_top("", index, 0) |> _append_bottom
  end
  
  defp _build_top('A', _, _, _), do: "A\n"
  defp _build_top([], acc, _, _), do: acc
  defp _build_top([h|t], acc, offset, inset) do
    do_top(h, t, acc, offset, inset)
  end
  
  
  defp do_top(?A, tail, acc, offset, inset) do
    _build_top(tail, acc <> String.duplicate(" ", offset) <> "A" <> String.duplicate(" ", offset) <> "\n", offset - 1, inset + 1)
  end
  
  defp do_top(char, tail, acc, offset, inset) do
    _build_top(tail, acc <> String.duplicate(" ", offset) <> @char_map[char] <> String.duplicate(" ", inset) <> @char_map[char] <> String.duplicate(" ", offset) <> "\n", offset - 1, inset + 2)
  end
  
  defp _append_bottom("A\n"), do: "A\n"
  defp _append_bottom(str) do
    bottom = str
    |> String.split("\n")
    |> Enum.reverse
    |> Enum.slice(2, 25)
    |> Enum.join("\n")
    str <> bottom <> "\n"
  end
end
