defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(1), do: 1
  def square(number), do: square(number - 1) * 2

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total, do: _total(64, 0)
  defp _total(1, sum), do: sum + 1
  defp _total(count, sum), do: _total(count - 1, sum + square(count))
end
