defmodule Wordy do

  @doc """
  Calculate the math problem in the sentence.
  """
  @operands ~r(\-?\d+)
  @operators ~r( plus | minus | multiplied by | divided by )
  @spec answer(String.t) :: integer
  def answer(<<"What is ", rest::binary>>) do
    operands = Regex.scan(@operands, rest, capture: :all)
    |> List.flatten
    |> Enum.map(fn num -> String.to_integer(num) end)
    
    operators = Regex.scan(@operators, rest, capture: :all) 
    |> List.flatten
    |> Enum.map(fn op -> String.trim(op) end)
    
    [op1|op_tail] = operands
    [fun1|fun_tail] =
      case length(operators) do
        x when x > 0 -> operators
        _ -> raise ArgumentError
      end
    calculate(op1, fun1, op_tail, fun_tail)
  end
  def answer(_), do: raise ArgumentError
  
  
  defp calculate(operand, operator, [h|_], []) do
    _apply(operator, operand, h)
  end
  defp calculate(operand, operator, [h|t], [fun1|_]) do
    _apply(operator, operand, h) |> _calculate(fun1, t)
  end
  defp calculate(_, _, _, _), do: ArgumentError
  
  defp _calculate(result, operator, [h|_]) do
    _apply(operator, result, h)
  end
  defp _calculate(_, _, _), do: ArgumentError
  
  defp _apply(operator, op1, op2) do
    case operator do
      "plus" -> op1 + op2
      "minus" -> op1 - op2
      "multiplied by" -> op1 * op2
      "divided by" -> div(op1, op2)
    end
  end
end
