defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, 1), do: str
  def encode(str, rails) do
    len = String.length(str)
    str
    |> String.graphemes
    |> Enum.zip(rails |> mark |> Stream.cycle)
    |> Enum.reduce(List.duplicate("", rails), fn {grapheme, index}, acc ->
      List.update_at(acc, index, &(&1 <> grapheme))
    end)
    |> Enum.join
  end

  def mark(1), do: [0]
  def mark(2), do: [0, 1]
  def mark(size) do
    Enum.to_list(0..size-1) ++ Enum.to_list(size-2..1)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, rails) do
    rails
    |> mark
    |> Stream.cycle
    |> Enum.take(String.length(str))
    |> Enum.with_index
    |> Enum.reduce(List.duplicate([], rails), fn {loc, index}, acc ->
      List.update_at(acc, loc, &(&1 ++ [index]))
    end)
    |> List.flatten
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort
    |> Enum.map(fn {_, g} -> g end)
    |> Enum.join
  end
end
