defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factors(number, 2)
  defp factors(n, candidate) when n < candidate, do: []
  defp factors(n, candidate) when rem(n, candidate) != 0, do: factors(n, candidate + 1)
  defp factors(n, candidate) do
    [candidate | factors(div(n,candidate), candidate)]
  end
end
