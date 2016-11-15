defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  
  @spec count(String.t) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> strip_punctuation
    |> iterate_and_count(%{})
  end
  
  defp strip_punctuation(sentence) do
    reg_ex = ~r/[^\p{L}\d-]+/u
    String.split(sentence, reg_ex, trim: true)
  end
  
  defp iterate_and_count([], map), do: map
  defp iterate_and_count([head|tail], map) do
    new_map = Map.update(map, head, 1, &(&1 + 1))
    iterate_and_count(tail, new_map)
  end
end
