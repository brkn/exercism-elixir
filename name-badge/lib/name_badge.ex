defmodule NameBadge do
  def print(id, name, department) when department == nil and id == nil, do: "#{name} - OWNER"
  def print(id, name, department) when id == nil, do: "#{name} - #{department |> String.upcase}"
  def print(id, name, department) do
    if department == nil do
      "[#{id}] - #{name} - OWNER"
    else
      "[#{id}] - #{name} - #{department |> String.upcase}"
    end
  end
end
