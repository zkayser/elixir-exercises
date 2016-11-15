defmodule BinTree do
  import Inspect.Algebra
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat ["(", to_doc(v, opts),
            ":", (if l, do: to_doc(l, opts), else: ""),
            ":", (if r, do: to_doc(r, opts), else: ""),
            ")"]
  end
end

defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  @type context :: :top | {:left, BT.t, context} | {:right, BT.t, context}
  @type t :: %Zipper{bt: BT.t, context: context}
  defstruct bt: nil, context: nil
  alias BinTree, as: BT
  alias Zipper, as: Z
  
  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    %Z{bt: bt, context: :top}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(%Z{bt: bt, context: :top}), do: bt
  def to_tree(z) do
    z |> up |> to_tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(z) do
    z.bt.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left(%Z{bt: %BT{value: _, left: nil, right: _}, context: _}), do: nil
  def left(%Z{bt: bt, context: context}) do
    %Z{bt: bt.left, context: {:left, bt, context}}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right(%Z{bt: %BT{value: _, left: _, right: nil}, context: _}), do: nil
  def right(%Z{bt: bt, context: context}) do
    %Z{bt: bt.right, context: {:right, bt, context}}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(%Z{bt: _, context: :top}), do: nil
  def up(%Z{bt: bt, context: {_, parent, context}}) do
    %Z{bt: parent, context: context}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(%Z{bt: %BT{value: _, left: left, right: right}, context: context}, v) do
    new_bt = %BT{value: v, left: left, right: right}
    %Z{bt: new_bt, context: update_context(new_bt, context)}
  end
  
  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(%Z{bt: %BT{value: val, left: _, right: right}, context: context}, l) do
    new_bt = %BT{value: val, left: l, right: right}
    %Z{bt: new_bt, context: update_context(new_bt, context)}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(%Z{bt: %BT{value: val, left: left, right: _}, context: context}, r) do
    new_bt = %BT{value: val, left: left, right: r}
    %Z{bt: new_bt, context: update_context(new_bt, context)}
  end
  
  @doc """
  Updates context dynamically
  """
  @spec update_context(BT.t, context) :: context
  def update_context(bt, context) do
    case context do
      {:left, %BT{value: val, left: _, right: right}, next} -> 
        {:left, %BT{value: val, left: bt, right: right},  update_context(%BT{value: val, left: bt, right: right}, next)}
      {:right, %BT{value: val, left: left, right: _}, next}  -> 
        {:right, %BT{value: val, left: left, right: bt}, update_context(%BT{value: val, left: left, right: bt}, next)}
      :top -> :top
    end
  end
end
