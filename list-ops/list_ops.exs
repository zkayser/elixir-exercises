defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l) when is_list(l) do
    _count(l, 0)
  end
  
  defp _count([], acc), do: acc
  defp _count([_s|t], acc) do
    _count(t, acc + 1)
  end
  
  @spec reverse(list) :: list
  def reverse(l) do
    _reverse(l, [])
  end
  
  defp _reverse([], acc), do: acc
  defp _reverse([h|t], acc) do
    _reverse(t, [h|acc])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    _map(l, f, [])
  end
  
  defp _map([], _, acc), do: reverse(acc)
  defp _map([h|t], f, acc) do
    _map(t, f, [f.(h)|acc])
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    _filter(l, f, [])
  end
  
  defp _filter([], _, acc), do: reverse(acc)
  defp _filter([h|t], f, acc) do
    if f.(h), do: _filter(t, f, [h|acc]), else: _filter(t, f, acc)
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h|t], acc, f) do
    reduce(t, f.(h, acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    _append(a, b, [])
  end
  
  defp _append([], [], acc), do: reverse(acc)
  defp _append([h|t], [], acc) do
    _append(t, [], [h|acc])
  end
  defp _append([], [h|t], acc) do
    _append([], t, [h|acc])
  end
  defp _append([h|t], b, acc) do
    _append(t, b, [h|acc])
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    _concat(ll, [])
  end
  
  defp _concat([], acc), do: reverse(acc)
  defp _concat([h|t], acc) when is_list(h) do
    do_concat(h, t, acc)
  end
  defp do_concat([], main_tail, acc), do: _concat(main_tail, acc)
  defp do_concat([h|t], main_tail, acc) do
    _concat([t|main_tail], [h|acc])
  end
end
