defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance('', ''), do: {:ok, 0}
  def hamming_distance(strand1, strand2) when strand1 === strand2, do: {:ok, 0}
  def hamming_distance(strand1, strand2) when length(strand1) == length(strand2) do
    strand1 |> Enum.zip(strand2) |> _hamming(0)
  end
  def hamming_distance(strand1, strand2), do: {:error, "Lists must be the same length"}
  
  defp _hamming([], count), do: {:ok, count}
  defp _hamming([h|t], count) do
    if elem(h, 0) == elem(h, 1), do: _hamming(t, count), else: _hamming(t, count + 1)
  end
      
  
end
