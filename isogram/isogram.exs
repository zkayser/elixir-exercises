defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @punctuation ~r(\p{P}|\s+)
  
  @spec isogram?(String.t) :: boolean
  def isogram?(sentence) do
    graphemes = Regex.replace(@punctuation, sentence, "")
    |> String.downcase
    |> String.graphemes
    graphemes === Enum.uniq(graphemes)
  end

end
