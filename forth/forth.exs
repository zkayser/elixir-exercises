defmodule Forth do
  @spaces 0..32 |> Enum.to_list
  @ints 48..57 |> Enum.to_list
  @reg 65..122 |> Enum.to_list
  @operators [42, 43, 45, 47]
  @numbers ~w(0 1 2 3 4 5 6 7 8 9)
  @operations %{"dup" => "dup", "swap" => "swap", "over" => "over", "drop" => "drop"}
  @evaluator %{stack: "", defs: @operations}
  @ops ~w(+ - * /)
  @opaque evaluator :: Enum.t

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    @evaluator
  end
  
  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t) :: evaluator
  def eval(ev, s) do
    unless String.first(s) == ":" do
      update = s
      |> sanitize
      |> valid?(Map.keys(ev[:defs]))
      |> insert_defs(ev[:defs])
      |> String.downcase
      |> _eval("")
      |> _eval_defs("")
      Map.put(ev, :stack, update)
    else
      if String.last(s) == ";" do
        defs = set_definitions(s)
        Map.put(ev, :defs, defs)
      else
        [_, rem] = String.split(s, ";", parts: 2)
        defs = set_definitions(s)
        eval(Map.put(ev, :defs, defs), rem |> String.trim)
      end
    end
  end

  defp _eval(<<int1, " ", int2, " ", op, rest::binary>>, str) when int1 in @ints and int2 in @ints and op in @operators do
    _eval(str <> Integer.to_string(apply_operation(op, int1, int2)) <> rest, "")
  end
  defp _eval(<<int1, " ", int2, " ", op>>, str) when int1 in @ints and int2 in @ints and op in @operators do
    str <> Integer.to_string(apply_operation(op, int1, int2))
  end
  defp _eval("", str), do: str
  defp _eval(<<head, rest::binary>>, str), do: _eval(rest, str <> <<head>>)
  
  defp _eval_defs(<<int1, " ", int2, " ", "swap", rest::binary>>, str) when int1 in @ints and int2 in @ints do
    _eval_defs((str <> <<int2>> <> " " <> <<int1>> <> rest), "")
  end
  defp _eval_defs(<<int1, " ", int2, " ", "swap">>, str) do
    str <> <<int2>> <> " " <> <<int1>>
  end
  defp _eval_defs(<<int, " ", "dup", rest::binary>>, str) when int in @ints do
    _eval_defs((str <> <<int>> <> " " <> <<int>> <> rest), "")
  end
  defp _eval_defs(<<int, " ", "dup">>, str) when int in @ints do
    str <> <<int>> <> " " <> <<int>>
  end
  defp _eval_defs(<<int, " ", "drop", rest::binary>>, str) when int in @ints do
    _eval_defs(str <> rest, "")
  end
  defp _eval_defs(<<int, " ", "drop">>, str) when int in @ints do
    str
  end
  defp _eval_defs(<<int1, " ", int2, " ", "over", rest::binary>>, str) when int1 in @ints and int2 in @ints do
    _eval_defs((str <> <<int1>> <> " " <> <<int2>> <> " " <> <<int1>> <> rest), "")
  end
  defp _eval_defs(<<int1, " ", int2, " ", "over">>, str) when int1 in @ints and int2 in @ints do
    str <> <<int1>> <> " " <> <<int2>> <> " " <> <<int1>>
  end
  defp _eval_defs(<<"drop", _::binary>>, _), do: raise Forth.StackUnderflow
  defp _eval_defs("drop", _), do: raise Forth.StackUnderflow
  defp _eval_defs(<<_, " ", "swap", _::binary>>, _), do: raise Forth.StackUnderflow
  defp _eval_defs(<<_, " ", "swap">>, _), do: raise Forth.StackUnderflow
  defp _eval_defs("swap", _), do: raise Forth.StackUnderflow
  defp _eval_defs("dup", _), do: raise Forth.StackUnderflow
  defp _eval_defs(<<_, " ", "over", _::binary>>, _), do: raise Forth.StackUnderflow
  defp _eval_defs(<<_, " ", "over">>, _), do: raise Forth.StackUnderflow
  defp _eval_defs("over", _), do: raise Forth.StackUnderflow
  defp _eval_defs("", str), do: str |> String.trim
  defp _eval_defs(<<head, rest::binary>>, str), do: _eval_defs(rest, str <> <<head>>)
  
  defp apply_operation(op, int1, int2) do
    int1 = <<int1>> |> String.to_integer
    int2 = <<int2>> |> String.to_integer
    case op do
      op when op == 42 -> apply(Kernel, :*, [int1, int2])
      op when op == 43 -> apply(Kernel, :+, [int1, int2])
      op when op == 45 -> apply(Kernel, :-, [int1, int2])
      op when op == 47 -> 
        if int2 != 0, do: apply(Kernel, :div, [int1, int2]), else: raise Forth.DivisionByZero
      _ -> raise ArgumentError
    end
  end
  
  def set_definitions(<<":", rest::binary>>), do: _set_definitions(rest)
  def set_definitions(_), do: @operations
  
  defp _set_definitions(str) do
    {[key|val], _} = str |> String.trim_leading |> String.split(" ") |> Enum.split_while(&(&1 != ";"))
    val = Enum.join(val, " ")
    unless Regex.match?(~r(\d+), key), do: Map.put(@operations, key, val), else: raise Forth.InvalidWord
  end
  
  def insert_defs(str, defs) do
    _insert_defs(Map.keys(defs), str, defs)
  end
  
  defp _insert_defs([], str, _), do: str
  defp _insert_defs([h|t], str, defs) do
    if String.contains?(str, h) do
      _insert_defs(t, String.replace(str, h, Map.get(defs, h)), defs)
    else
      _insert_defs(t, str, defs)
    end
  end
  
  def sanitize(str) do
    str |> strip_ogham |> remove_whitespace
  end
  
  defp strip_ogham(str), do: str |> String.replace(" ", " ")
  
  defp remove_whitespace(str) do
    str |> to_charlist |> _remove_whitespace([]) |> List.to_string |> String.trim
  end
  
  defp _remove_whitespace([], acc), do: acc |> _intersperse_spaces([])
  defp _remove_whitespace([h|t], acc) do
    if h in @spaces, do: _remove_whitespace(t, acc), else: _remove_whitespace(t, acc ++ [h])
  end
  defp _intersperse_spaces([], acc), do: acc
  defp _intersperse_spaces([h|t], acc) do
    cond do
      h == 45 && (List.first(t) in @ints || List.first(t) in @operators) ->
        _intersperse_spaces(t, acc ++ [h] ++ [" "])
      h == 45 && List.first(t) in @reg -> _intersperse_spaces(t, acc ++ [h])
      h in @ints || h in @operators -> _intersperse_spaces(t, acc ++ [h] ++ [" "])
      true -> _intersperse_spaces(t, acc ++ [h])
    end
  end
  
  defp valid?(str, keys) do
    split = str |> String.downcase |> String.split
    if _valid?(split, keys), do: str, else: raise Forth.UnknownWord
  end
  
  defp _valid?(stack, keys) do
    stack |> Enum.all?(fn el -> defined?(el, keys) end)
  end
  
  defp defined?(el, keys) do
    el in @numbers || el in @ops || el in keys
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t
  def format_stack(ev) do
    ev[:stack]
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception [word: nil]
    def message(e), do: "invalid word: #{inspect e.word}"
  end

  defmodule UnknownWord do
    defexception [word: nil]
    def message(e), do: "unknown word: #{inspect e.word}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
