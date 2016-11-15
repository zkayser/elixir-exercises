defmodule Bob do

  def hey(input) do
    cond do
      String.last(input) == "?" ->
        "Sure."
      String.trim_leading(input) == "" ->
        "Fine. Be that way!"
      String.upcase(input) == input && String.downcase(input) != input ->
        "Whoa, chill out!"
      true ->
        "Whatever."
    end
  end
end
