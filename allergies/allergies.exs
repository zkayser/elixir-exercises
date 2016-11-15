defmodule Allergies do
  use Bitwise
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @allergies %{
    1 => "eggs", 2 => "peanuts", 4 => "shellfish", 8 => "strawberries",
    16 => "tomatoes", 32 => "chocolate", 64 => "pollen", 128 => "cats"
  }
  @spec list(non_neg_integer) :: [String.t]
  def list(0), do: []
  def list(flags) do
    for {value, allergy} <- @allergies,  band(flags, value) == value, do: allergy
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t) :: boolean
  def allergic_to?(0, _), do: false
  def allergic_to?(flags, item) do
    item in list(flags)
  end
end
