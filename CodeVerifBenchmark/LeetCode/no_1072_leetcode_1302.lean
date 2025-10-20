import Mathlib

namespace no_1072_leetcode_1302


-- Define the binary tree structure
inductive BTree (α : Type) where
  | nil : BTree α
  | node (val : Nat) (left : BTree α) (right : BTree α) : BTree α
deriving Repr

-- Precondition auxiliary definitions
/-- Computes the maximum depth of a binary tree -/
def maxDepth (root : BTree Nat) : Nat :=
  match root with
  | BTree.node val left right => 1 + max (maxDepth left) (maxDepth right)
  | BTree.nil => 0

/-- Checks if a node is a leaf (has no children) -/
def isLeaf (node : BTree Nat) : Bool :=
  match node with
  | BTree.node _ BTree.nil BTree.nil => true
  | _ => false

/-- Sums the values of all leaves at a specific depth -/
def sumLeavesAtDepth (root : BTree Nat) (targetDepth : Nat) : Nat :=
  go root targetDepth
where
  go (node : BTree Nat) (depth : Nat) : Nat :=
    match node, depth with
    | BTree.node val left right, 0 => 0  -- Not at target depth yet
    | BTree.node val BTree.nil BTree.nil, 1 => val  -- Leaf at target depth
    | BTree.node val left right, 1 => 0   -- Internal node at target depth
    | BTree.node val left right, d + 1 => go left d + go right d
    | BTree.nil, _ => 0

/-- Gets all leaves with their depths -/
def leavesWithDepths (root : BTree Nat) (currentDepth : Nat := 0) : List (Nat × Nat) :=
  match root with
  | BTree.node val BTree.nil BTree.nil => [(val, currentDepth)]  -- Leaf node
  | BTree.node val left right => 
      leavesWithDepths left (currentDepth + 1) ++ leavesWithDepths right (currentDepth + 1)
  | BTree.nil => []

/-- Computes the sum of values of leaves at the maximum depth -/
def sumOfDeepestLeaves (root : BTree Nat) : Nat :=
  let leafDepths := leavesWithDepths root
  if leafDepths = [] then 0
  else
    let maxDepth := (leafDepths.map Prod.snd).foldl max 0
    (leafDepths.filter (fun (_, depth) => depth = maxDepth)).map Prod.fst |>.sum

-- Precondition definitions
@[reducible, simp]
def deepestLeavesSum_precond (root : BTree Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute the sum of deepest leaves using a single traversal -/
def deepestLeavesSumAux (root : BTree Nat) : Nat × Nat :=
  go root 0
where
  go (node : BTree Nat) (currentDepth : Nat) : Nat × Nat :=
    match node with
    | BTree.node val BTree.nil BTree.nil =>
      -- Leaf node: return (depth, value)
      (currentDepth, val)
    | BTree.node val left right =>
      let (leftDepth, leftSum) := go left (currentDepth + 1)
      let (rightDepth, rightSum) := go right (currentDepth + 1)
      if leftDepth = rightDepth then
        (leftDepth, leftSum + rightSum)
      else if leftDepth > rightDepth then
        (leftDepth, leftSum)
      else
        (rightDepth, rightSum)
    | BTree.nil =>
      -- Empty node: return (0, 0) to indicate no contribution
      (0, 0)

-- Main function definitions
def deepestLeavesSum (root : BTree Nat) (h_precond : deepestLeavesSum_precond (root)) : Nat :=
  -- !benchmark @start code
  let (maxDepth, sum) := deepestLeavesSumAux root
  sum
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def deepestLeavesSum_postcond (root : BTree Nat) (result: Nat) (h_precond : deepestLeavesSum_precond (root)) : Prop :=
  -- !benchmark @start postcond
  result = sumOfDeepestLeaves root
  -- !benchmark @end postcond


-- Proof content
theorem deepestLeavesSum_postcond_satisfied (root: BTree Nat) (h_precond : deepestLeavesSum_precond (root)) :
    deepestLeavesSum_postcond (root) (deepestLeavesSum (root) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1072_leetcode_1302