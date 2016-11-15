defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """
  # The Erlang calendar module's day_of_the_week/1
  # function returns the day of the week represented
  # by numbers with the following mapping.
  @nums_to_weekday %{
    1 => :monday,
    2 => :tuesday,
    3 => :wednesday,
    4 => :thursday,
    5 => :friday,
    6 => :saturday,
    7 => :sunday
  }

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    last_day = :calendar.last_day_of_the_month(year, month)
    build_calendar(year, month, last_day)
    |> Map.get(weekday)
    |> find_date_for(schedule)
    |> format(year, month)
  end
  
  defp build_calendar(year, month, last_day) do
    first = :calendar.day_of_the_week({year, month, 1})
    calendar = Map.new(Map.values(@nums_to_weekday), fn x -> {x, []} end)
    _build_calendar(calendar, 1, first, last_day)
  end
  
  defp _build_calendar(calendar, date, weekday, last_day) when date <= last_day do
    wd = weekday |> number_to_weekday
    {_, calendar} = Map.get_and_update(calendar, wd, fn current_list -> {current_list, current_list ++ [date]} end)
    next = get_next_weekday(weekday)
    _build_calendar(calendar, date + 1, next, last_day)
  end
  defp _build_calendar(calendar, _, _, _), do: calendar
    
  
  defp number_to_weekday(number) do
    Map.get(@nums_to_weekday, number)
  end
  
  defp get_next_weekday(number) when number < 7, do: number + 1
  defp get_next_weekday(_), do: 1
  
  defp find_date_for(list, :first), do: Enum.at(list, 0)
  defp find_date_for(list, :second), do: Enum.at(list, 1)
  defp find_date_for(list, :third), do: Enum.at(list, 2)
  defp find_date_for(list, :fourth), do: Enum.at(list, 3)
  defp find_date_for(list, :last), do: List.last(list)
  defp find_date_for(list, :teenth) do
    [h|_] = Enum.filter(list, fn x -> x > 12 && x < 20 end)
    h
  end
  
  defp format(day, year, month), do: {year, month, day}
end
