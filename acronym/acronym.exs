defmodule Acronym do

  @abbreviation_regex ~r/(?:\b[a-z]|[A-Z])/
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split
    |> Enum.map(&strip_excess_characters(&1))
    |> Enum.join
    |> String.upcase
  end
  
  defp strip_excess_characters(str) do
    Regex.scan(@abbreviation_regex, str)
  end
end
