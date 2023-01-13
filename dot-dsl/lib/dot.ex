defmodule Dot do
  defmacro graph(ast) do
    ast
    |> to_graph_statements
    |> Enum.reduce(Graph.new(), fn graph_statement, accumulated_graph ->
      case graph_statement do
        {:graph, _line, [attrs]} when is_list(attrs) ->
          Graph.put_attrs(accumulated_graph, attrs)

        {node_id, _line, nil} ->
          Graph.add_node(accumulated_graph, node_id)

        {node_id, _line, [attrs]} when is_list(attrs) ->
          Graph.add_node(accumulated_graph, node_id, attrs)

        {:--, _line, [{left_node, _line_num_left, nil}, {right_node, _line_num_right, nil}]} ->
          Graph.add_edge(accumulated_graph, left_node, right_node)

        {:--, _line, [{left_node, _line_num_left, nil}, {right_node, _line_num_right, [attrs]}]}
        when is_list(attrs) ->
          Graph.add_edge(accumulated_graph, left_node, right_node, attrs)

        _ ->
          raise ArgumentError, inspect(graph_statement)
      end
    end)
    |> Macro.escape()
  end

  defp to_graph_statements(do: {:__block__, _, statements}), do: statements
  defp to_graph_statements(do: single_statement), do: [single_statement]
end
