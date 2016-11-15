defmodule RNATranscription do
  @complements %{?G => ?C, ?C => ?G, ?T => ?A, ?A => ?U}
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples
  
  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    dna |> Enum.map(&(@complements[&1]))
  end
end
