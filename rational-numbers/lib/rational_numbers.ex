defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a_num, a_den}, {b_num, b_den}), do: {a_num * b_den + b_num * a_den, a_den * b_den} |> reduce

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, {b_num, b_den}), do: add(a, {b_num * -1, b_den})

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a_num, a_den}, {b_num, b_den}), do: { a_num * b_num, a_den * b_den } |> reduce

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(num, {den_num, den_den}) when den_den * den_num > 0, do: multiply(num, {den_den, den_num})
  def divide_by(num, {den_num, den_den}) when den_den * den_num < 0 do
    multiply(num, {Kernel.abs(den_den) * -1, Kernel.abs(den_num)})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({num, den}), do: {Kernel.abs(num), Kernel.abs(den)} |> reduce

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({a_num, a_den}, n) when n == 0, do: {1, 1}
  def pow_rational({a_num, a_den}, n) when n > 0, do: {a_num ** n, a_den ** n}
  def pow_rational({a_num, a_den}, n) when n < 0, do: {a_den ** (n * -1), a_num ** (n * -1)}

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, n) do
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({x, y}) do
    gcd = Integer.gcd(x, y)
    { x / gcd , y /gcd }
  end
end
