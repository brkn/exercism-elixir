# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @first_id 1

  def start(opts \\ []), do: Agent.start(fn -> {@first_id, []} end, opts)

  def list_registrations(pid) do
    {_, list} = pid |> Agent.get(& &1)

    list
  end

  def register(pid, register_to),
    do:
      pid
      |> Agent.get_and_update(fn {id, list} ->
        plot = %Plot{plot_id: id, registered_to: register_to}

        {plot, {id + 1, [plot | list]}}
      end)

  def release(pid, plot_id),
    do:
      pid
      |> Agent.get_and_update(fn {id, list} ->
        plot = find_plot(list, plot_id)

        {:ok, {id, List.delete(list, plot)}}
      end)

  def get_registration(pid, plot_id),
    do: Agent.get(pid, fn {_, list} -> find_plot(list, plot_id) end)

  defp find_plot(list, plot_id) do
    Enum.find(
      list,
      {:not_found, "plot is unregistered"},
      fn
        %Plot{plot_id: ^plot_id, registered_to: _} -> true
        _ -> false
      end
    )
  end
end
