defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part(ast, acc) do
    new_acc =
      case ast do
        {:def, _, [function_definition, _]} -> [node_to_push(function_definition) | acc]
        {:defp, _, [function_definition, _]} -> [node_to_push(function_definition) | acc]
        _ -> acc
      end

    {ast, new_acc}
  end

  def decode_secret_message(string) do
    {_, message} = string |> to_ast |> Macro.postwalk([], &decode_secret_message_part/2)

    message |> Enum.reverse() |> Enum.join()
  end

  defp node_to_push({:when, _, [{_, _, params}, _]}) when params in [nil, []], do: ""

  defp node_to_push({:when, _, [{fn_name, _, params}, _]}),
    do: fn_name |> to_string |> String.slice(0, length(params))

  defp node_to_push({_, _, params}) when params in [nil, []], do: ""

  defp node_to_push({fn_name, _, params}),
    do: fn_name |> to_string |> String.slice(0, length(params))
end
