import Mathlib

namespace no_173_leetcode_203


-- Precondition auxiliary definitions
inductive ListNode
  | nil : ListNode
  | cons (val : Int) (next : ListNode) : ListNode

def ListNode.all (p : Int → Prop) : ListNode → Prop
  | .nil => True
  | .cons val next => p val ∧ ListNode.all p next

def ListNode.length : ListNode → Nat
  | .nil => 0
  | .cons _ next => 1 + next.length

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def removeElements_precond (head : ListNode) (val : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to recursively remove elements from the list -/
def removeElementsAux : ListNode → Int → ListNode
  | .nil, _ => .nil
  | .cons val' next, val => 
      if val' = val then 
        removeElementsAux next val
      else 
        .cons val' (removeElementsAux next val)

-- Main function definitions
def removeElements (head : ListNode) (val : Int) (h_precond : removeElements_precond (head) (val)) : ListNode :=
  -- !benchmark @start code
  removeElementsAux head val
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def ListNode.toList : ListNode → List Int
  | .nil => []
  | .cons val next => val :: next.toList

def List.removeAll' (val : Int) : List Int → List Int
  | [] => []
  | x :: xs => if x = val then removeAll' val xs else x :: removeAll' val xs

def ListNode.ofList : List Int → ListNode
  | [] => .nil
  | x :: xs => .cons x (ofList xs)

-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def removeElements_postcond (head : ListNode) (val : Int) (result: ListNode) (h_precond : removeElements_precond (head) (val)) : Prop :=
  -- !benchmark @start postcond
  let input_list := head.toList
  let expected_list := List.removeAll' val input_list
  result.toList = expected_list
  -- !benchmark @end postcond
  -- !benchmark @end postcond


-- Proof content
theorem removeElements_postcond_satisfied (head: ListNode) (val: Int) (h_precond : removeElements_precond (head) (val)) :
    removeElements_postcond (head) (val) (removeElements (head) (val) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_173_leetcode_203