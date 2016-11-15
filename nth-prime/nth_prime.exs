defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  def nth(0), do: raise ArgumentError
  def nth(1), do: 2
  def nth(count) do
    Stream.resource(
      fn -> [3, 2] end,
      fn(prime_list) -> 
        case prime_list do
          prime_list when length(prime_list) <= count ->
            {prime_list, _next_prime(prime_list, Enum.at(prime_list, 0) + 1)}
          _ -> 
            {:halt, prime_list}
        end
      end,
      fn(prime_list) -> prime_list end
    )
    |> Enum.max
  end
  

  defp _next_prime(prime_list, next) do
    if is_prime?(next), do: [next | prime_list], else: _next_prime(prime_list, next + 1)
  end
  
  defp is_prime?(number) do
    max = round(:math.sqrt(number))
    2..max
    |> Enum.any?(fn value -> rem(number, value) == 0 end)
    |> Kernel.not
  end
end
