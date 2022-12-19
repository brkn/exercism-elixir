defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c)
      when a <= 0
      when b <= 0
      when c <= 0 do
    {:error, "all side lengths must be positive"}
  end

  def kind(a, b, c)
      when a + b < c
      when b + c < a
      when a + c < b do
    {:error, "side lengths violate triangle inequality"}
  end

  def kind(a, b, c) when a == b and b == c, do: {:ok, :equilateral}
  def kind(a, b, c) when a == b or b == c or a == c, do: {:ok, :isosceles}
  def kind(_a, _b, _c), do: {:ok, :scalene}
end
