defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts} | {:error, error}
  @callback handle_frame(opts(), frame_number(), opts()) :: dot()

  defmacro __using__(_options) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) when rem(frame_number, 4) == 0,
    do: %DancingDots.Dot{dot | opacity: dot.opacity / 2}

  @impl DancingDots.Animation
  def handle_frame(dot, _frame_number, _opts), do: dot
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @init_velocity_opt_error_prefix "The :velocity option is required, and its value must be a number."

  @impl DancingDots.Animation
  def init(opts) do
    velocity = opts |> Keyword.get(:velocity)

    cond do
      is_number(velocity) == false ->
        {:error, "#{@init_velocity_opt_error_prefix} Got: #{inspect(velocity)}"}

      true ->
        {:ok, opts}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts),
    do: %DancingDots.Dot{dot | radius: dot.radius + (frame_number - 1) * opts[:velocity]}
end
