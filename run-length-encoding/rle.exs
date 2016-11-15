defmodule RunLengthEncoder do
  @decode_regex ~r/(\d+)([A-Z])/
  @encode_regex ~r{(\w)\1*}
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """
  @spec encode(String.t) :: String.t
  def encode(""), do: ""
  def encode(string) do
    Regex.scan(@encode_regex, string)
    |> Enum.map(&_compress/1)
    |> Enum.join
  end
  
  defp _compress([repeated_string, letter]) do
    Integer.to_string(String.length(repeated_string)) <> letter
  end
  
  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.scan(@decode_regex, string, capture: :all_but_first)
    |> Enum.reduce("", &_expand/2)
  end
  
  defp _expand([count, letter], acc) do
    acc <> String.duplicate(letter, String.to_integer(count))
  end
end
