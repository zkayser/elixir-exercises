defmodule Clock do
  defstruct hour: 0, minute: 0
  @type t :: %Clock{hour: number, minute: number}
  
  defimpl String.Chars, for: Clock do
    def to_string(%Clock{hour: hour, minute: minute}) do
      time = (hour * 60) + minute
      day_clock = rem(time, 60 * 24)
      cond do
        day_clock >= 0 ->
          hours = div(day_clock, 60)
          mins = rem(day_clock, 60)
          Clock.format_time(hours, mins)
        true -> 
          subtract = abs(rem(day_clock, 60 * 24))
          hours = div(subtract, 60)
          mins = rem(subtract, 60)
          hour = case hours do
            hours when hours == 0 and mins == 0 -> 0
            hours when hours == 0 and mins != 0 -> 23
            hours when hours != 0 and mins != 0 -> 24 - (hours + 1)
            _ -> 24 - hours
          end
          min = case mins do
            mins when mins == 0 -> 0
            _ -> 60 - mins
          end
          Clock.format_time(hour, min)
      end
    end
  end
  
  def format_time(hours, min) do
    cond do
      hours < 10 && min < 10 -> "0#{hours}:0#{min}"
      hours < 10 && hours >= 0 -> "0#{hours}:#{min}"
      min < 10 && min >= 0 -> "#{hours}:0#{min}"
      true -> "#{hours}:#{min}"
    end
  end

  @doc """
  Returns a string representation of a clock:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    clock = %Clock{hour: hour, minute: minute}
    |> to_string
    <<h1, h2, ":", m1, m2>> = clock
    h = String.to_integer(<<h1,  h2>>)
    m = String.to_integer(<<m1, m2>>)
    %Clock{hour: h, minute: m}
  end

  @doc """
  Adds two clock times:

      iex> Clock.add(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    total = to_mins(hour, minute + add_minute)
    day = rem(total, 60 * 24)
    new_hour = div(day, 60)
    new_minute = rem(day, 60)
    %Clock{hour: new_hour, minute: new_minute}
  end
  
  defp to_mins(hours, minutes) do
    (hours * 60) + minutes
  end
end
