defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a NucleotideCount strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  
  def count(strand, nucleotide) when nucleotide in @nucleotides do
    do_count(strand, nucleotide, 0)
  end
  def count(_, _), do: raise ArgumentError
  
  defp do_count([], _, acc), do: acc + 0
  defp do_count([head|tail], nucleotide, acc) when head in @nucleotides do
    case (head == nucleotide) do
      true -> 
        do_count(tail, nucleotide, acc + 1)
      _ -> 
        do_count(tail, nucleotide, acc)
    end
  end
  defp do_count([head|tail], _, _) when not head in @nucleotides, do: raise ArgumentError
  
  
  
  
  


  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    @nucleotides
    |> Enum.into(%{}, &{&1, 0})
    |> do_histogram(strand)
  end
  
  defp do_histogram(map, []), do: map
  defp do_histogram(map, [head|tail]) when head in @nucleotides do
    Enum.reduce([head|tail], map, fn nucleotide, map -> Map.update(map, nucleotide, 1, &(&1 + 1)) end)
  end
  defp do_histogram(_, _), do: raise ArgumentError
    
end
