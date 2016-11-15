defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: { :ok, kind } | { :error, String.t }
  def kind(0, 0, 0), do: {:error, "all side lengths must be positive"}
  def kind(a, b, c) when a < 0 or b < 0 or c < 0, do: {:error, "all side lengths must be positive"}
  def kind(a, b, c) when a == b and b == c, do: {:ok, :equilateral}
  def kind(a, b, c) do
    if fulfills_triangle_inequality?(a, b, c) do 
      _kind(a, b, c) 
    else
      {:error, "side lengths violate triangle inequality"}
    end
  end
  
  def fulfills_triangle_inequality?(a, b, c) do
    # Degenerate case
    unless a == b + c || b == a + c || c == a + b do
      a <= b + c && b <= a + b && c <= a + b
    else
      false
    end
  end
  
  defp _kind(a, b, c) when a == b or a == c or b == c, do: {:ok, :isosceles}
  defp _kind(_, _, _), do: {:ok, :scalene}
end
