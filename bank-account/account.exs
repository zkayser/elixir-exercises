defmodule BankAccount do
  use GenServer
  
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    GenServer.start_link(__MODULE__, %{balance: 0})
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Genserver.terminate({:normal, nil})
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.cast(account, {:update, amount})
  end
  
  def handle_call(:balance, _from, state) do
    balance = Map.get(state, :balance)
    { :reply, balance, %{balance: balance}}
  end
  
  def handle_cast({:update, amount}, state) do
    balance = Map.get(state, :balance)
    new_balance = balance + amount
    {:noreply, %{balance: new_balance}}
  end
end
