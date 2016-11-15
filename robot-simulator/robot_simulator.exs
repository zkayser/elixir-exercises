defmodule RobotSimulator do
  @directions [:north, :south, :east, :west]
  @invalid ~r([^L|^R|^A])
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: { integer, integer }) :: any
  def create(direction \\ :north, position \\ {0, 0}) when direction in @directions 
  and is_tuple(position) and tuple_size(position) == 2 and is_number(elem(position, 0))
  and is_number(elem(position, 1)) do
    %{direction: direction, position: position}
  end
  def create(direction, _) when not direction in @directions do
    { :error, "invalid direction" }
  end
  def create(_, _), do: { :error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t ) :: any
  def simulate(robot, instructions) do
    if Regex.match?(@invalid, instructions) do
      { :error, "invalid instruction" }
    else
      instructions |> String.codepoints |> _simulate(robot)
    end
  end
  
  defp _simulate([], robot), do: robot
  defp _simulate([instruction|tail], robot) do
    case instruction do
      "L" -> _simulate(tail, turn_left(robot))
      "R" -> _simulate(tail, turn_right(robot))
      "A" -> _simulate(tail, advance(robot))
    end
  end
  
  defp turn_left(robot) do
    case RobotSimulator.direction(robot) do
      :north -> Map.put(robot, :direction, :west)
      :east -> Map.put(robot, :direction, :north)
      :south -> Map.put(robot, :direction, :east)
      :west -> Map.put(robot, :direction, :south)
    end
  end
  
  defp turn_right(robot) do
    case RobotSimulator.direction(robot) do
      :north -> Map.put(robot, :direction, :east)
      :east -> Map.put(robot, :direction, :south)
      :south -> Map.put(robot, :direction, :west)
      :west -> Map.put(robot, :direction, :north)
    end
  end
  
  def advance(robot) do
    case RobotSimulator.direction(robot) do
      :north -> 
        pos = RobotSimulator.position(robot)
        new_pos = {elem(pos, 0), elem(pos, 1) + 1}
        Map.put(robot, :position, new_pos)
      :east ->
        pos = RobotSimulator.position(robot)
        new_pos = {elem(pos, 0) + 1, elem(pos, 1)}
        Map.put(robot, :position, new_pos)
      :south -> 
        pos = RobotSimulator.position(robot)
        new_pos = {elem(pos, 0), elem(pos, 1) - 1}
        Map.put(robot, :position, new_pos)
      :west ->
        pos = RobotSimulator.position(robot)
        new_pos = {elem(pos, 0) - 1, elem(pos, 1)}
        Map.put(robot, :position, new_pos)
    end
  end
  

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    Map.get(robot, :direction)
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: { integer, integer }
  def position(robot) do
    Map.get(robot, :position)
  end
end
