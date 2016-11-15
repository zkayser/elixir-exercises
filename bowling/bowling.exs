defmodule Bowling do
  use GenServer
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    {:ok, game} = GenServer.start_link(__MODULE__, {[], {:first, 1, 0}}, name: Game)
    game
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `:ok`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t
  def roll(game, roll) do
    GenServer.call(game, {:roll, roll})
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t
  def score(game) do
    GenServer.call(game, {:score})
  end
  
  def init(game) do
    {:ok, game}
  end
  
  def handle_call({:roll, roll}, _from, {game, {ball, frame, frame_score}}) do
    
    cond do 
      roll < 0 -> {:reply, {:error, "Pins must have a value from 0 to 10"}, {game, {ball, frame, frame_score}}}
      roll > 10 -> {:reply, {:error, "Pins must have a value from 0 to 10"}, {game, {ball, frame, frame_score}}}
      frame_score + roll > 10 -> {:reply, {:error, "Pin count exceeds pins on the lane"}, {game, {ball, frame, frame_score}}}
      ball == :first && roll == 10 -> {:reply, Game, {game ++ [{frame, roll, :strike}], {:first, frame + 1, 0}}}
      ball == :second && roll + frame_score == 10 -> {:reply, Game, {game ++ [{frame, roll, :spare}], {:first, frame + 1, 0}}}
      ball == :first -> {:reply, Game, {game ++ [{frame, roll, :normal}], {:second, frame, roll}}}
      ball == :second -> {:reply, Game, {game ++ [{frame, roll, :normal}], {:first, frame + 1, 0}}}
      true -> {:reply, "Hit catch-all clause", {game, {ball, frame, frame_score}}}
    end
    
  end
  
  def handle_call({:score}, _from, {game, state}) do
    {last_frame, _, _} = List.last(game)
    unless last_frame < 10 do
      {:reply, compute_score(game, []) |> reduce_score, {game, state}}
    else
      {:reply, {:error, "Score cannot be taken until the end of the game"}, {game, state}}
    end
  end
  
  defp compute_score([], acc), do: acc
  defp compute_score([{frame, _, _}|tail], acc) when frame > 10, do: acc
  defp compute_score([{frame, 10, :strike}|tail], acc) when frame <= 10 do
    [{_, roll, _}|t] = tail
    [{_, roll2, _}|_] = t
    compute_score(tail, acc ++ [{frame, 10 + roll + roll2}])
  end
  defp compute_score([{frame, _, :normal}|[{frame, _, :spare}|tail]], acc) when frame <= 10 do
    [{_, roll, _}|_] = tail
    compute_score(tail, acc ++ [{frame, 10 + roll}])
  end
    
  defp compute_score([{frame, roll, :normal}|[{frame, roll2, :normal}|tail]], acc) do
    compute_score(tail, acc ++ [{frame, roll + roll2}])
  end
  
  defp reduce_score(score_list) do
    Enum.reduce(score_list, 0, fn {_, score}, acc -> acc + score end)
  end
end
