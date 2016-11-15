defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    non_primes = for num <- 2..limit,
        p <- 2..limit,
        multiplier <- 2..limit,
        (p * multiplier) <= limit,
        p * multiplier == num,
        do: num
    non_primes
    |> Enum.uniq
    |> sieve(limit)
  end
  
  defp sieve(non_primes, limit) do
    2..limit
    |> Enum.to_list
    |> Enum.filter(fn val -> not val in non_primes end)
  end
end
