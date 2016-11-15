defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph([do: {:__block__, [_], dsl_ast}] = ast) do
    handle_errors(dsl_ast)
    attrs = get_attrs(dsl_ast, []) |> List.flatten |> Enum.sort
    edges = get_edges(dsl_ast, []) |> List.flatten |> Enum.sort
    nodes = get_nodes(dsl_ast, []) |> List.flatten |> Enum.sort
    quote do
      %Graph{attrs: unquote(attrs), edges: unquote(Macro.escape(edges)), nodes: unquote(nodes)}
    end
  end
  
  defmacro graph([do: dsl_ast]) do
    case dsl_ast do
      {:graph, _, _} -> 
        attrs = get_attrs(dsl_ast, []) |> List.flatten
        quote do: %Graph{attrs: unquote(attrs)}
      {:--, _, _} ->
        edges = get_edges(dsl_ast, []) |> List.flatten
        quote do: %Graph{edges: unquote(Macro.escape(edges))}
      {node, _, _} when is_atom(node) ->
        nodes = get_nodes(dsl_ast, []) |> List.flatten
        quote do: %Graph{nodes: unquote(nodes)}
      nil -> quote do: %Graph{}
      _ -> quote do: raise ArgumentError
    end
  end
  
  
  defp handle_errors([]), do: :ok
  defp handle_errors([h|_]) when is_integer(h), do: raise ArgumentError
  defp handle_errors([_|t]), do: handle_errors(t)
    
  defp get_attrs([], acc), do: acc
  defp get_attrs({:graph, _, args}, acc), do: acc ++ args
  defp get_attrs([{:graph, _, args}|t], acc) do
    get_attrs(t, acc ++ args)
  end
  defp get_attrs([_|t], acc) do
    get_attrs(t, acc)
  end
  
  defp get_edges([], acc), do: acc
  defp get_edges({:--, _, [{edge1, _, nil}, {edge2, _, nil}]}, acc)
    when is_atom(edge1) and is_atom(edge2) do
      acc ++ [{edge1, edge2, []}]
  end
  defp get_edges({:--, _, [{edge1, _, nil}, {edge2, _, options}]}, acc) 
    when is_atom(edge1) and is_atom(edge2) do
      acc ++ [{edge1, edge2, List.flatten(options)}]
  end
  defp get_edges([{:--, _, [{edge1, _, nil}, {edge2, _, options}]}|t], acc) 
    when is_atom(edge1) and is_atom(edge2) do
      get_edges(t, acc ++ [{edge1, edge2, List.flatten(options)}])
  end
  defp get_edges([_|t], acc), do: get_edges(t, acc)
  defp get_edges(_, _), do: raise ArgumentError
  
  defp get_nodes([], acc), do: acc
  defp get_nodes({node, _, nil}, acc) when node != :graph do
    acc ++ [{node, []}]
  end
  defp get_nodes({node, _, options}, acc) when node != :graph  do
    if options |> List.flatten |> List.first |> Kernel.is_tuple do
      acc ++ [{node, List.flatten(options)}]
    else
      raise ArgumentError
    end
  end
  defp get_nodes([{nodes, _, nil}|t], acc) when nodes in [:a, :b, :c] do
    get_nodes(t, acc ++ [{nodes, []}])
  end
  defp get_nodes([{nodes, _, options}|t], acc) when nodes in [:a, :b, :c] do
    get_nodes(t, acc ++ [{nodes, List.flatten(options)}])
  end
  defp get_nodes([_|t], acc), do: get_nodes(t, acc)
end
