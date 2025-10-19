import Mathlib

-- Precondition auxiliary definitions
inductive ListNode where
  | nil : ListNode
  | cons (val : Int) (next : ListNode) : ListNode

namespace ListNode

def length : ListNode → Nat
  | .nil => 0
  | .cons _ next => 1 + next.length

def toList : ListNode → List Int
  | .nil => []
  | .cons val next => val :: next.toList

def isSorted : ListNode → Prop
  | .nil => True
  | .cons _ .nil => True
  | .cons val1 (.cons val2 next) => val1 ≤ val2 ∧ (ListNode.cons val2 next).isSorted

def isPermutationOf : ListNode → ListNode → Prop
  | l1, l2 => l1.toList = l2.toList

end ListNode

-- Precondition definitions
@[reducible, simp]
def insertionSortList_precond (head : ListNode) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Insert a value into a sorted list, maintaining the sorted property -/
def insertIntoSortedList : Int → ListNode → ListNode
  | val, .nil => .cons val .nil
  | val, .cons hd tl =>
    if val ≤ hd then
      .cons val (.cons hd tl)
    else
      .cons hd (insertIntoSortedList val tl)

/-- Convert a list to a ListNode -/
def List.toListNode : List Int → ListNode
  | [] => .nil
  | h :: t => .cons h (t.toListNode)

-- Main function definitions
def insertionSortList (head : ListNode) (h_precond : insertionSortList_precond (head)) : ListNode :=
  -- !benchmark @start code
  match head with
    | .nil => .nil
    | .cons val .nil => head
    | .cons val next =>
      let sortedRest := insertionSortList next (by simp)
      insertIntoSortedList val sortedRest
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for the postcondition

-- Postcondition definitions
@[reducible, simp]
def insertionSortList_postcond (head : ListNode) (result: ListNode) (h_precond : insertionSortList_precond (head)) : Prop :=
  -- !benchmark @start postcond
  result.isSorted ∧ head.isPermutationOf result
  -- !benchmark @end postcond


-- Proof content
theorem insertionSortList_postcond_satisfied (head: ListNode) (h_precond : insertionSortList_precond (head)) :
    insertionSortList_postcond (head) (insertionSortList (head) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof