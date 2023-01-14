defmodule CircularBuffer do
  use GenServer

  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start_link(__MODULE__, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read_oldest)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.call(buffer, :clear)
  end

  @impl GenServer
  def init(capacity), do: {:ok, %{capacity: capacity, stack: []}}

  @impl GenServer
  def handle_call(:read_oldest, _from, %{stack: []} = state),
    do: {:reply, {:error, :empty}, state}

  def handle_call(:read_oldest, _from, %{stack: stack} = state) do
    {value, new_stack} = List.pop_at(stack, -1)

    {:reply, {:ok, value}, %{state | stack: new_stack}}
  end

  @impl GenServer
  def handle_call({:write, _}, _from, %{stack: stack, capacity: cap} = state)
      when length(stack) == cap,
      do: {:reply, {:error, :full}, state}

  def handle_call({:write, item}, _from, %{stack: stack} = state) do
    {:reply, :ok, %{state | stack: [item | stack]}}
  end

  @impl GenServer
  def handle_call(:clear, _from, state), do: {:reply, :ok, %{state | stack: []}}

  @impl GenServer
  def handle_call({:overwrite, item}, _from, %{stack: stack, capacity: cap} = state)
      when length(stack) != cap,
      do: {:reply, :ok, %{state | stack: [item | stack]}}

  def handle_call({:overwrite, item}, _from, %{stack: stack} = state) do
    {_, new_stack} = List.pop_at(stack, -1)

    {:reply, :ok, %{state | stack: [item | new_stack]}}
  end
end
