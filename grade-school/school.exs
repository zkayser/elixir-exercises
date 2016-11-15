defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t, integer) :: map
  def add(db, name, grade) do
    Map.update(db, grade, [name], fn value -> value ++ [name] end)
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t]
  def grade(db, grade) do
    grade = Map.get(db, grade)
    if grade, do: grade, else: []
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t]}]
  def sort(db) do
    keys = Map.keys(db)
    |> Enum.sort
    values = Map.values(db)
    |> Enum.map(&Enum.sort/1)
    Enum.zip(keys, values)
  end
end
