defmodule TakeANumberDeluxe do
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    with {:ok, state} <-
           TakeANumberDeluxe.State.new(
             Keyword.fetch!(init_arg, :min_number),
             Keyword.fetch!(init_arg, :max_number),
             Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
           ) do
      GenServer.start_link(__MODULE__, state)
    else
      _ -> {:error, :invalid_configuration}
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.call(machine, :reset_state)
  end

  # Server callbacks

  @impl GenServer
  def init(%{auto_shutdown_timeout: auto_shutdown_timeout} = state),
    do: {:ok, state, auto_shutdown_timeout}

  @impl GenServer
  def handle_call(
        :report_state,
        _from,
        %{auto_shutdown_timeout: auto_shutdown_timeout} = machine
      ),
      do: {:reply, machine, machine, auto_shutdown_timeout}

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, {:ok, new_state}}
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, {:ok, state} = machine) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, next_number, new_state} -> {:reply, {:ok, next_number}, {:ok, new_state}}
      {:error, error} -> {:reply, {:error, error}, machine}
    end
  end

  @impl GenServer
  def handle_call(
        :reset_state,
        _from,
        {:ok,
         %{
           min_number: min_number,
           max_number: max_number,
           auto_shutdown_timeout: auto_shutdown_timeout
         }}
      ) do
    {
      :reply,
      :ok,
      TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout),
      auto_shutdown_timeout
    }
  end

  # @impl GenServer
  # def handle_info(:timeout, _state) do
  #   exit
  # end

  # def handle_info(_msg, state) do
  #   {:noreply, state, state.auto_shutdown_timeout}
  # end
end
