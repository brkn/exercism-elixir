defmodule BankAccount do
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
    {:ok, pid} = Agent.start(fn -> 0 end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account), do: account |> Agent.stop()

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    cond do
      Process.alive?(account) -> Agent.get(account, fn state -> state end)
      true -> {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    cond do
      Process.alive?(account) -> account |> Agent.update(fn state -> state + amount end)
      true -> {:error, :account_closed}
    end
  end
end
