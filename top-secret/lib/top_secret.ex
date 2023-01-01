defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part(ast, acc) do
    new_acc =
      case ast do
        {:def, _, [{:when, _, [{fn_name, _, params}, _]}, _]} -> [node_to_push(fn_name, params) | acc]
        {:defp, _, [{:when, _, [{fn_name, _, params}, _]}, _]} -> [node_to_push(fn_name, params) | acc]

        {:def, _, [{fn_name, _, params}, _]} -> [node_to_push(fn_name, params) | acc]
        {:defp, _, [{fn_name, _, params}, _]} -> [node_to_push(fn_name, params) | acc]
        _ -> acc
      end

    {ast, new_acc}


    # IO.inspect { ast |> Macro.to_string()}
    # IO.inspect ast
    # nil
  end

  def decode_secret_message(string) do
  end

  def node_to_push(fn_name, params) when params in [nil, []], do: ""
  def node_to_push(fn_name, params), do: fn_name |> to_string |> String.slice(0, length(params))
end
