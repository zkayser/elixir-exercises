defmodule Luhn do
  @doc """
  Calculates the total checksum of a number
  """
  @spec checksum(String.t()) :: integer
  def checksum(number) do
    number
    |> String.reverse
    |> String.codepoints
    |> Stream.map(&Integer.parse/1)
    |> Stream.map(&(elem(&1, 0)))
    |> Enum.with_index
    |> Stream.map(&_checksum(&1))
    |> Enum.sum
  end
  
  defp _checksum(tuple) when elem(tuple, 1) == 0, do: elem(tuple, 0)
  defp _checksum(tuple) when rem(elem(tuple, 1), 2) == 0, do: elem(tuple, 0)
  defp _checksum(tuple), do: handle_second_digit(elem(tuple, 0))
  
  defp handle_second_digit(num) when num < 5, do: num * 2
  defp handle_second_digit(num), do: (num * 2) - 9
    

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number
    |> checksum
    |> rem(10) == 0
  end

  @doc """
  Creates a valid number by adding the correct
  checksum digit to the end of the number
  """
  @spec create(String.t()) :: String.t()
  def create(number) do
    cond do
      valid?(number) -> number
      true -> 
        0..9
        |> Stream.map(&to_string((&1)))
        |> Stream.map(&(number <> &1))
        |> Enum.filter(&valid?(&1))
        |> hd
    end
  end
end
