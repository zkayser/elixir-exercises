defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  
  def compare([], []), do: :equal
  def compare([], [nil]), do: :sublist
  def compare([nil], []), do: :superlist
  def compare(a, b) when is_list(a) and is_list(b) do
    _compare(a, b)
  end
  
  defp _compare(a, b) when length(a) > length(b) do
    if b in Enum.chunk(a, length(b), 1), do: :superlist, else: :unequal
  end
  defp _compare(a, b) when length(a) < length(b) do
    if a in Enum.chunk(b, length(a), 1), do: :sublist, else: :unequal
  end
  defp _compare(a, b) when length(a) == length(b) do
    if a === b, do: :equal, else: :unequal
  end
end
