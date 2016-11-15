defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) do
    cond do
      rem(number, 3) == 0 && rem(number, 5) == 0 && rem(number, 7) == 0 ->
        "PlingPlangPlong"
      rem(number, 3) == 0 && rem(number, 5) == 0 ->
        "PlingPlang"
      rem(number, 3) == 0 && rem(number, 7) == 0 ->
        "PlingPlong"
      rem(number, 5) == 0 && rem(number, 7) == 0 ->
        "PlangPlong"
      rem(number, 3) == 0 ->
        "Pling"
      rem(number, 5) == 0 ->
        "Plang"
      rem(number, 7) == 0 ->
        "Plong"
      true ->
        Integer.to_string(number)
    end
  end
end
