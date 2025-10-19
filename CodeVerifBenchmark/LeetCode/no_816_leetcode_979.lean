import Mathlib

-- Define the TreeNode structure
inductive TreeNode
  | nil : TreeNode
  | node (val : Nat) (left : TreeNode) (right : TreeNode) : TreeNode

namespace TreeNode

-- Auxiliary definitions for precondition
def size : TreeNode → Nat
  | .nil => 0
  | .node _ l r => 1 + l.size + r.size

def sum : TreeNode → Nat
  | .nil => 0
  | .node val l r => val + l.sum + r.sum

-- Precondition definitions
@[reducible, simp]
def validCoins (root : TreeNode) : Prop :=
  root.size > 0 ∧ root.sum = root.size

def distributeCoins_precond (root : TreeNode) : Prop :=
  -- !benchmark @start precond
  root.validCoins
  -- !benchmark @end precond

-- Code auxiliary definitions
def distributeCoins_aux (root : TreeNode) : Nat × Int :=
  match root with
  | .node val left right =>
    let (l_moves, l_excess) := distributeCoins_aux left
    let (r_moves, r_excess) := distributeCoins_aux right
    let my_excess := (val : Int) + l_excess + r_excess - 1
    (l_moves + r_moves + (Int.natAbs l_excess) + (Int.natAbs r_excess), my_excess)
  | .nil => (0, 0)

-- Postcondition auxiliary definitions
def distributeCoins_moves (root : TreeNode) : Nat :=
  match root with
  | .node val left right =>
    let l_moves := distributeCoins_moves left
    let r_moves := distributeCoins_moves right
    let l_excess := (left.sum - left.size : Int)
    let r_excess := (right.sum - right.size : Int)
    let my_excess := (val : Int) + l_excess + r_excess - 1
    l_moves + r_moves + (Int.natAbs l_excess) + (Int.natAbs r_excess)
  | .nil => 0

end TreeNode

-- Main function definitions
def distributeCoins (root : TreeNode) (h_precond : TreeNode.distributeCoins_precond root) : Nat :=
  -- !benchmark @start code
  TreeNode.distributeCoins_aux root |>.1
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def distributeCoins_postcond (root : TreeNode) (result: Nat) (h_precond : TreeNode.distributeCoins_precond root) : Prop :=
  -- !benchmark @start postcond
  result = TreeNode.distributeCoins_moves root
  -- !benchmark @end postcond

-- Proof content
theorem distributeCoins_postcond_satisfied (root: TreeNode) (h_precond : TreeNode.distributeCoins_precond root) :
    distributeCoins_postcond root (distributeCoins root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof