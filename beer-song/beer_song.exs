defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t
  def verse(number) do
    top_refrain(number) <> bottom_refrain(number)
  end
  
  defp singularize(word) do
    String.replace_trailing(word, "s", "")
  end
  
  defp set_case(1, word), do: "1 " <> singularize(word) <> " of beer"
  defp set_case(0, word), do: "No more #{word} of beer"
  defp set_case(number, word), do: "#{number} #{word} of beer"
  
  defp top_refrain(number) do
    set_case(number - 1, "bottles") <> " on the wall, " <> String.downcase(set_case(number - 1, "bottles")) <> ".\n"
  end
  defp bottom_refrain(1) do
    "Go to the store and buy some more, " <> set_case(99, "bottles") <> " on the wall.\n"
  end
  defp bottom_refrain(number) do
    "Take #{one?(number)} down and pass it around, " <> String.downcase(set_case(number - 2, "bottles")) <> " on the wall.\n"
  end
  
  defp one?(number) do
    if number > 2, do: "one", else: "it"
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t) :: String.t
  def lyrics(range \\ 100..1) do
    range 
    |> Enum.to_list 
    |> Enum.reverse 
    |> Enum.reduce("", &(verse(&1) <> "\n" <> &2))
    |> String.replace_trailing("\n\n", "\n")
  end
end
