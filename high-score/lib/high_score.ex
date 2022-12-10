defmodule HighScore do
  @initial_score 0

  def new(), do: %{}

  def add_player(scores, name, score \\ @initial_score), do: scores |> Map.merge(%{name => score})

  def remove_player(scores, name), do: scores |> Map.delete(name)

  def reset_score(scores, name), do: add_player(scores, name)

  def update_score(scores, name, score), do: Map.update(scores, name, score, &(&1 + score))

  def get_players(scores), do: scores |> Map.keys()
end
