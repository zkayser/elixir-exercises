defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns :error if it is not possible to compute the right amount of coins.
    Otherwise returns the tuple {:ok, map_of_coins}

    ## Examples

      iex> Change.generate(3, [5, 10, 15])
      :error

      iex> Change.generate(18, [1, 5, 10])
      {:ok, %{1 => 3, 5 => 1, 10 => 1}}

  """

  @spec generate(integer, list) :: {:ok, map} | :error
  def generate(_, []), do: :error
  def generate(amount, values) do
    values
    |> Map.new(fn x -> {x, 0} end)
    |> count_coins(amount, Enum.max(values))
    |> format
  end
  
  defp count_coins(coin_map, amount, max) when amount > max do
    remaining_amount = rem(amount, max)
    {_, coin_map} = Map.get_and_update(coin_map, max, 
        fn current -> 
          {current, current + div(amount, max)} 
        end)
    coin_list = Map.keys(coin_map)
    new_list = List.delete(coin_list, max)
    new_max = Enum.max(new_list)
    count_coins(coin_map, remaining_amount, new_max, new_list, amount)
  end
  defp count_coins(coin_map, amount, max) do
    if Enum.all?(Map.keys(coin_map), fn x -> x > amount end) do
      :error
    else
      new_list = List.delete(Map.keys(coin_map), max)
      new_max = Enum.max(new_list)
      count_coins(coin_map, amount, new_max, new_list, amount)
    end
  end
  
  defp count_coins(coin_map, amount, _, [], total) do
    if count_equals_amount?(coin_map, total) do
      coin_map
    else
      next_highest_coin(Map.keys(coin_map))
      count_coins(Map.new(Map.keys(coin_map), fn x -> {x, 0} end), total, next_highest_coin(Map.keys(coin_map)))
    end
  end
  defp count_coins(coin_map, amount, max, coin_list, total) do
    remaining_amount = rem(amount, max)
    {_, coin_map} = Map.get_and_update(coin_map, max,
      fn current ->
        {current, current + div(amount, max)}
      end)
    new_list = List.delete(coin_list, max)
    unless new_list == [], do: new_max = Enum.max(new_list), else: new_max = 0
    count_coins(coin_map, remaining_amount, new_max, new_list, total)
  end
  
  defp count_equals_amount?(map, amount) do
    total = Enum.reduce(Map.to_list(map), 0, fn x, acc -> acc + (elem(x, 0) * elem(x, 1)) end)
    total == amount
  end
  
  defp next_highest_coin(coin_list) when length(coin_list) > 1 do
    new_list = List.delete(coin_list, Enum.max(coin_list))
    next_coin = Enum.max(new_list)
  end
  
  defp format(:error), do: :error
  defp format(coin_map), do: {:ok, coin_map} 
end
