defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @gigasecond 1_000_000_000
  
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) :: :calendar.datetime

  def from({{_, _, _}, {_, _, _}} = datetime) do
    :calendar.datetime_to_gregorian_seconds(datetime)
    |> Kernel.+(@gigasecond)
    |> :calendar.gregorian_seconds_to_datetime
  end
end
