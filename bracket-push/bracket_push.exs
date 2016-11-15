defmodule BracketPush do

  @targets ["{", "}", "[", "]", "(", ")"]
  @opening ["{", "[", "("]
  @closing ["}", "]", ")"]
  @brackets %{"(" => ")", "[" => "]", "{" => "}"}
  
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(""), do: true
  def check_brackets(str) do
    str 
    |> String.codepoints
    |> Enum.filter(&(&1 in @targets)) 
    |> Enum.join 
    |> _check_brackets([])
  end
  
  defp _check_brackets("", []), do: true
  defp _check_brackets("", _), do: false
  defp _check_brackets(<<open_bracket::binary-size(1), rest::binary>>, stack) when open_bracket in @opening do
    _check_brackets(rest, [open_bracket | stack])
  end
  defp _check_brackets(<<close_bracket::binary-size(1), _::binary>>, [])
    when close_bracket in @closing, do: false
  defp _check_brackets(<<close_bracket::binary-size(1), rest::binary>>, [open_bracket | stack]) when close_bracket in @closing do
    if @brackets[open_bracket] == close_bracket, do: _check_brackets(rest, stack), else: false
  end
end
