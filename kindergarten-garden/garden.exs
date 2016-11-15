defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """
  @students [:alice, :bob, :charlie, :david, :eve, :fred, :ginny, :harriet, :ileana, :joseph, :kincaid, :larry]
  @plants %{?R => :radishes, ?C => :clover, ?G => :grass, ?V => :violets}
  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @students) do
    [first_row|tail] = info_string |> String.split("\n", parts: 2)
    [second_row|_] = tail
    plants = sort_plants(first_row, second_row, [])
    names = Enum.sort(student_names)
    info = Map.new(names, fn x -> {x, {}} end)
    update = Enum.zip(names, plants) |> Map.new 
    Map.merge(info, update)
  end
  
  defp sort_plants("", "", acc), do: acc
  defp sort_plants(<<p1, p2, rest_1::binary>>, <<p3, p4, rest_2::binary>>, acc) do
    sort_plants(rest_1, rest_2, acc ++ [{@plants[p1], @plants[p2], @plants[p3], @plants[p4]}])
  end
end
