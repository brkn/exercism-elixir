defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)

    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> %{input => :ok} |> Map.merge(results)
      {:EXIT, ^pid, _reason} -> %{input => :error} |> Map.merge(results)
    after
      100 -> %{input => :timeout} |> Map.merge(results)
    end
  end

  def reliability_check(calculator, inputs) do
    trap_exit_flag = Process.flag(:trap_exit, true)

    results =
      inputs
      |> Enum.map(&start_reliability_check(calculator, &1))
      |> Enum.reduce(%{}, &await_reliability_check_result/2)

    Process.flag(:trap_exit, trap_exit_flag)

    results
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
