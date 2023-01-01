defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(_item, %Character{health: health, mana: mana}) do
      {nil, %Character{health: health + 5, mana: mana}}
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(%ManaPotion{strength: strength}, %Character{health: health, mana: mana}) do
      {%EmptyBottle{}, %Character{health: health, mana: mana + strength}}
    end
  end

  defimpl Edible, for: Poison do
    def eat(_poison, %Character{mana: mana}) do
      {%EmptyBottle{}, %RPG.Character{health: 0, mana: mana}}
    end
  end
end
