defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    base
    |> String.downcase
    |> String.graphemes
    |> Enum.sort
    |> _match(candidates, base)
  end
  
  def _match(sorted, candidates, base) do
    candidates
    |> Stream.reject(&(String.length(&1) != String.length(base)))
    |> Stream.map(&({&1, String.downcase(&1) |> String.graphemes |> Enum.sort}))
    |> Stream.reject(&(elem(&1, 1) != sorted))
    |> Stream.map(&(elem(&1, 0)))
    |> Enum.reject(&(String.downcase(&1) == String.downcase(base)))
  end
end
