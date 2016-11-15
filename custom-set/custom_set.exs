defmodule CustomSet do
  defstruct map: []

  @opaque t :: %__MODULE__{map: map}

  @spec new(Enum.t) :: t
  def new([]) do
    %CustomSet{}
  end
  def new(enumerable) do
    %CustomSet{map: Enum.uniq(enumerable)}
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set), do: custom_set.map |> length == 0

  @spec contains?(t, any) :: boolean
  def contains?(%CustomSet{map: []}, _), do: false
  def contains?(custom_set, element) do
    element in custom_set.map
  end

  @spec subset?(t, t) :: boolean
  def subset?(%CustomSet{map: []}, %CustomSet{map: []}), do: true
  def subset?(%CustomSet{map: []}, %CustomSet{map: _}), do: true
  def subset?(%CustomSet{map: _}, %CustomSet{map: []}), do: false
  def subset?(%CustomSet{map: [h|t]}, %CustomSet{map: set}) do
    if h in set, do: subset?(t, set), else: false
  end
  def subset?([], _), do: true
  def subset?([h|t], set) do
    if h in set, do: subset?(t, set), else: false
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%CustomSet{map: []}, %CustomSet{map: []}), do: true
  def disjoint?(%CustomSet{map: []}, %CustomSet{map: _set}), do: true
  def disjoint?(%CustomSet{map: _set}, %CustomSet{map: []}), do: true
  def disjoint?(%CustomSet{map: [h|t]}, %CustomSet{map: set}) do
    if h in set, do: false, else: disjoint?(t, set)
  end
  def disjoint?([], _), do: true
  def disjoint?([h|t], set) do
    if h in set, do: false, else: disjoint?(t, set)
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    custom_set_1.map |> Enum.sort == custom_set_2.map |> Enum.sort
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    %{custom_set | map: Enum.uniq(custom_set.map ++ [element])}
  end

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: []}, %CustomSet{map: []}), do: %CustomSet{}
  def intersection(%CustomSet{map: []}, %CustomSet{map: _}), do: %CustomSet{}
  def intersection(%CustomSet{map: _}, %CustomSet{map: []}), do: %CustomSet{}
  def intersection(%CustomSet{map: set1}, %CustomSet{map: set2}), do: _intersection(set1, set2, [])
  defp _intersection([], _, acc), do: %CustomSet{map: acc}
  defp _intersection([h|t], set2, acc) do
    if h in set2, do: _intersection(t, set2, acc ++ [h]), else: _intersection(t, set2, acc)
  end

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: []}, %CustomSet{map: []}), do: %CustomSet{}
  def difference(%CustomSet{map: []}, %CustomSet{map: _}), do: %CustomSet{}
  def difference(%CustomSet{map: set}, %CustomSet{map: []}), do: new(set)
  def difference(%CustomSet{map: set1}, %CustomSet{map: set2}), do: _difference(set1, set2, [])
  defp _difference([], _, acc), do: new(acc)
  defp _difference([h|t], set2, acc) do
    if h in set2, do: _difference(t, set2, acc), else: _difference(t, set2, acc ++ [h])
  end

  @spec union(t, t) :: t
  def union(%CustomSet{map: []}, %CustomSet{map: []}), do: %CustomSet{}
  def union(%CustomSet{map: set}, %CustomSet{map: []}), do: new(set)
  def union(%CustomSet{map: []}, %CustomSet{map: set}), do: new(set)
  def union(%CustomSet{map: set1}, %CustomSet{map: set2}) do
    new((set1 ++ set2) |> Enum.uniq)
  end
end
