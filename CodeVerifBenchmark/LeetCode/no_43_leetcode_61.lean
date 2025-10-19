import Mathlib

-- Precondition auxiliary definitions
/-- A simple linked list node structure -/
inductive ListNode where
  | nil : ListNode
  | cons (val : Int) (next : ListNode) : ListNode
deriving Repr, BEq

/-- Get the length of a linked list -/
def ListNode.length : ListNode → Nat
  | .nil => 0
  | .cons _ next => 1 + next.length

/-- Convert a linked list to a list of values -/
def ListNode.toList : ListNode → List Int
  | .nil => []
  | .cons val next => val :: next.toList

/-- Convert a list of values to a linked list -/
def ListNode.ofList : List Int → ListNode
  | [] => .nil
  | h :: t => .cons h (ListNode.ofList t)

/-- Append two linked lists -/
def ListNode.append : ListNode → ListNode → ListNode
  | .nil, ys => ys
  | .cons x xs, ys => .cons x (xs.append ys)

/-- Take the first n elements of a linked list -/
def ListNode.take : Nat → ListNode → ListNode
  | 0, _ => .nil
  | n+1, .nil => .nil
  | n+1, .cons x xs => .cons x (ListNode.take n xs)

/-- Drop the first n elements of a linked list -/
def ListNode.drop : Nat → ListNode → ListNode
  | 0, xs => xs
  | n+1, .nil => .nil
  | n+1, .cons _ xs => ListNode.drop n xs

-- Precondition definitions
@[reducible, simp]
def rotateRight_precond (head : ListNode) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Rotate a linked list to the right by k positions -/
def rotateRightAux (head : ListNode) (k : Nat) : ListNode :=
  let len := head.length
  if len = 0 then head
  else
    let effectiveK := k % len
    if effectiveK = 0 then head
    else
      let splitPoint := len - effectiveK
      let firstPart := head.take splitPoint
      let secondPart := head.drop splitPoint
      secondPart.append firstPart

-- Main function definitions
def rotateRight (head : ListNode) (k : Nat) (h_precond : rotateRight_precond (head) (k)) : ListNode :=
  -- !benchmark @start code
  rotateRightAux head k
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Rotate a list to the right by k positions -/
def rotateListRight (lst : List Int) (k : Nat) : List Int :=
  let len := lst.length
  if len = 0 then lst
  else
    let effectiveK := k % len
    let splitPoint := len - effectiveK
    let firstPart := lst.take splitPoint
    let secondPart := lst.drop splitPoint
    secondPart ++ firstPart

-- Postcondition definitions
@[reducible, simp]
def rotateRight_postcond (head : ListNode) (k : Nat) (result: ListNode) (h_precond : rotateRight_precond (head) (k)) : Prop :=
  -- !benchmark @start postcond
  let inputList := head.toList
  let outputList := result.toList
  let expectedOutput := rotateListRight inputList k
  outputList = expectedOutput
  -- !benchmark @end postcond


-- Proof content
theorem rotateRight_postcond_satisfied (head: ListNode) (k: Nat) (h_precond : rotateRight_precond (head) (k)) :
    rotateRight_postcond (head) (k) (rotateRight (head) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

