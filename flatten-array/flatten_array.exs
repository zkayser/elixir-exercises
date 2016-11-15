defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    _flatten(list, [])
    |> Enum.reject(fn x -> x == nil end)
  end
  
  defp _flatten([h|t], tail) when is_list(h) do
    _flatten(h, _flatten(t, tail))
  end
  defp _flatten([h|t], tail) do
    [h|_flatten(t, tail)]
  end
  defp _flatten([], tail), do: tail
end
