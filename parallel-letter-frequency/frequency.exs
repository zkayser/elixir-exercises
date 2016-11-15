defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @non_letter_regex ~r([\d+]|[\p{P}]|[\s+])
  
  @spec frequency([String.t], pos_integer) :: map
  def frequency([], _), do: []
  def frequency(texts, workers) do
    texts
    |> Stream.flat_map(&String.split/1)
    |> Stream.chunk(workers, workers, [])
    |> Stream.flat_map(&process_texts/1)
    |> Enum.to_list
    |> merge_results(%{})
  end
  
  defp process_texts(texts) do
    texts
    |> Enum.map(&Task.async(fn -> process_text(&1) end))
    |> Enum.map(&Task.await(&1))
  end
  
  defp process_text(text) do
    Regex.replace(@non_letter_regex, text, "")
    |> String.downcase
    |> String.graphemes
    |> count(%{})
  end
  
  defp count([], acc), do: acc
  defp count([h|t], acc) do
    count(t, Map.update(acc, h, 1, fn x -> x + 1 end))
  end
  
  defp merge_results([], map), do: map
  defp merge_results([h|t], map) do
    merge_results(t, Map.merge(map, h, fn (_, value1, value2) -> value1 + value2 end))
  end
end


