import Mathlib

-- Precondition auxiliary definitions
/-- A linked list node. -/
structure ListNode where
  val : Nat
  next : Option ListNode
  deriving Repr, BEq

/-- Converts a linked list to a list of natural numbers. -/
def ListNode.toList (head : ListNode) : List Nat :=
  head.val :: match head.next with
    | none => []
    | some node => node.toList
decreasing_by sorry

/-- Converts a linked list to a natural number. -/
def ListNode.toNat (head : ListNode) : Nat :=
  let digits := head.toList
  let len := digits.length
  digits.enum.foldl (fun acc (i, d) => acc + d * (10 ^ (len - 1 - i))) 0

/-- Converts a natural number to a linked list. -/
def Nat.toListNode (n : Nat) : ListNode :=
  let digits := (Nat.digits 10 n).reverse
  let rec go : List Nat → ListNode
  | [] => ⟨0, none⟩  -- This case should not occur due to non-empty input
  | [d] => ⟨d, none⟩
  | d :: ds => ⟨d, some (go ds)⟩
  go (if digits = [] then [0] else digits)

/-- Checks if a linked list is valid (values in 0-9). -/
def ListNode.valid (head : ListNode) : Prop :=
  head.val < 10 ∧
  match head.next with
  | none => True
  | some next => next.valid
decreasing_by sorry

/-- Checks if a linked list has no leading zeros (except for the number 0). -/
def ListNode.noLeadingZero (head : ListNode) : Prop :=
  head.val ≠ 0 ∨ (head.val = 0 ∧ head.next = none)

-- Precondition definitions
@[reducible, simp]
def doubleIt_precond (head : ListNode) : Prop :=
  -- !benchmark @start precond
  head.valid ∧ head.noLeadingZero
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Doubles the value of a linked list node representing a number. -/
def ListNode.doubleIt (head : ListNode) : ListNode :=
  Nat.toListNode (head.toNat * 2)

-- Main function definitions
def doubleIt (head : ListNode) (h_precond : doubleIt_precond head) : ListNode :=
  -- !benchmark @start code
  head.doubleIt
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def doubleIt_postcond (head : ListNode) (result : ListNode) (h_precond : doubleIt_precond head) : Prop :=
  -- !benchmark @start postcond
  let input_num := head.toNat
  let expected_num := input_num * 2
  let expected_list := Nat.toListNode expected_num
  result.toNat = expected_num ∧
  result.valid ∧
  result.noLeadingZero
  -- !benchmark @end postcond


-- Proof content
theorem doubleIt_postcond_satisfied (head : ListNode) (h_precond : doubleIt_precond head) :
    doubleIt_postcond head (doubleIt head h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof