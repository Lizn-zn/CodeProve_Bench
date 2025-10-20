import Mathlib

namespace no_333_leetcode_404


-- Precondition auxiliary definitions
inductive TreeNode where
  | nil : TreeNode
  | node (val : Int) (left : TreeNode) (right : TreeNode) : TreeNode

def isLeaf (t : TreeNode) : Bool :=
  match t with
  | TreeNode.nil => true
  | TreeNode.node _ TreeNode.nil TreeNode.nil => true
  | _ => false

def sumOfLeftLeavesAux (root : TreeNode) : Int :=
  match root with
  | TreeNode.nil => 0
  | TreeNode.node _ left right =>
    let leftSum := if isLeaf left then
                     match left with
                     | TreeNode.node val _ _ => val
                     | TreeNode.nil => 0
                   else sumOfLeftLeavesAux left
    leftSum + sumOfLeftLeavesAux right

-- Precondition definitions
@[reducible, simp]
def sumOfLeftLeaves_precond (root : TreeNode) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def sumOfLeftLeavesAuxNat : TreeNode → Nat
  | TreeNode.nil => 0
  | TreeNode.node val left right =>
    let leftSum := if isLeaf left then
                     match left with
                     | TreeNode.node v _ _ => v.toNat
                     | TreeNode.nil => 0
                   else sumOfLeftLeavesAuxNat left
    leftSum + sumOfLeftLeavesAuxNat right

-- Main function definitions
def sumOfLeftLeaves (root : TreeNode) (h_precond : sumOfLeftLeaves_precond (root)) : Nat :=
  -- !benchmark @start code
  sumOfLeftLeavesAuxNat root
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sumOfLeftLeaves_postcond (root : TreeNode) (result: Nat) (h_precond : sumOfLeftLeaves_precond (root)) : Prop :=
  -- !benchmark @start postcond
  result = sumOfLeftLeavesAux root
  -- !benchmark @end postcond


-- Proof content
theorem sumOfLeftLeaves_postcond_satisfied (root: TreeNode) (h_precond : sumOfLeftLeaves_precond (root)) :
    sumOfLeftLeaves_postcond (root) (sumOfLeftLeaves (root) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_333_leetcode_404