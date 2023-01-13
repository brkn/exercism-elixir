defmodule Dot do
  defmacro graph(ast) do
    [do: {_, _, block}] = ast

    block
    |> Enum.reduce(Graph.new(), fn block_line, accumulated_graph ->
      case block_line do
        {:graph, _line, [attrs]} ->
          Graph.put_attrs(accumulated_graph, attrs)

        {node_id, _line, [attrs]} ->
          Graph.add_node(accumulated_graph, node_id, attrs)

        # {:--, _line, [{left_node, _line_num_left, nil}, {right_node, _line_num_right, [attrs]}]} ->
        #   Graph.add_edge(accumulated_graph, left_node, right_node, attrs)
      end
    end)
  end
end

# graph(foo: 1)
# graph(title: "Testing Attrs")
# graph([])
# graph(bar: true)
# graph[[title: "Bad"]]

# ast #=> [
#   do: {:__block__, [line: 71],
#    [
#      {:graph, [line: 78], [[foo: 1]]},
#      {:graph, [line: 79], [[title: "Testing Attrs"]]},
#      {:graph, [line: 80], [[]]},
#      {:a, [line: 81], [[color: :green]]},
#      {:c, [line: 82], [[]]},
#      {:b, [line: 83], [[label: "Beta!"]]},
#      {:--, [line: 84], [{:b, [line: 84], nil}, {:c, [line: 84], [[]]}]},
#      {:--, [line: 85],
#       [{:a, [line: 85], nil}, {:b, [line: 85], [[color: :blue]]}]},
#      {:graph, [line: 86], [[bar: true]]}
#    ]}
# ]
