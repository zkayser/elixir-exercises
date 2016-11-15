defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _), do: :not_found
  def search(tuple, value), do: _search(tuple, value, 0, tuple_size(tuple))
  
  defp _search(_, _, low, high) when low > high, do: :not_found
  defp _search(tuple, value, low, high) do
    pivot = div(high + low, 2)
    case elem(tuple, pivot) do
      ^value -> {:ok, pivot}
      x when x > value -> _search(tuple, value, low, pivot - 1)
      x when x < value -> _search(tuple, value, pivot + 1, high)
    end
  end
end
