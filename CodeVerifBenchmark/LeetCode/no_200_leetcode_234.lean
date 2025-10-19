import Mathlib

-- Precondition auxiliary definitions
/-- A simple singly-linked list node structure -/
structure ListNode where
  val : Nat
  next : Option ListNode
deriving Repr

/-- Get the list of values from the linked list -/
def ListNode.values : ListNode → List Nat
  | ⟨val, none⟩ => [val]
  | ⟨val, some next⟩ => val :: next.values

/-- Check if a list is a palindrome -/
def List.isPalindrome (l : List Nat) : Bool :=
  l = l.reverse

/-- The length of a linked list -/
def ListNode.length : ListNode → Nat
  | ⟨_, none⟩ => 1
  | ⟨_, some next⟩ => 1 + next.length

/-- Generate all possible valid linked lists with given constraints -/
inductive ValidListNode : ListNode → Prop where
  | single : ∀ (val : Nat), val ≤ 9 → ValidListNode ⟨val, none⟩
  | cons : ∀ (val : Nat) (next : ListNode),
      val ≤ 9 →
      ValidListNode next →
      ValidListNode ⟨val, some next⟩

-- Precondition definitions
@[reducible, simp]
def isPalindrome_precond (head : ListNode) : Prop :=
  -- !benchmark @start precond
  ∃ (h : ValidListNode head), head.length ≥ 1 ∧ head.length ≤ 100000
  -- !benchmark @end precond

-- Code auxiliary definitions
/-- Append a node to the end of a linked list -/
def ListNode.append (list : ListNode) (node : ListNode) : ListNode :=
  match list with
  | ⟨val, none⟩ => ⟨val, some node⟩
  | ⟨val, some next⟩ => ⟨val, some (next.append node)⟩

/-- Reverse a linked list -/
def ListNode.reverse (head : ListNode) : ListNode :=
  match head with
  | ⟨val, none⟩ => ⟨val, none⟩
  | ⟨val, some next⟩ =>
    let reversedNext := next.reverse
    ListNode.append reversedNext ⟨val, none⟩
  termination_by head.length
  decreasing_by
    simp_wf
    cases next
    simp[ListNode.length]

/-- Get the nth node of a linked list -/
def ListNode.get? : ListNode → Nat → Option ListNode
  | ⟨val, next⟩, 0 => some ⟨val, next⟩
  | ⟨_, some next⟩, n' + 1 => next.get? n'
  | ⟨_, none⟩, _ + 1 => none

/-- Compare two linked lists for value equality -/
def ListNode.valuesEq : ListNode → ListNode → Bool
  | ⟨val1, none⟩, ⟨val2, none⟩ => val1 == val2
  | ⟨val1, some next1⟩, ⟨val2, some next2⟩ => val1 == val2 && next1.valuesEq next2
  | _, _ => false

/-- Find the middle node of a linked list -/
def ListNode.middle (head : ListNode) : ListNode :=
  let len := head.length
  let midIdx := len / 2
  match head.get? midIdx with
  | some node => node
  | none => head

/-- Split the list into two halves -/
def ListNode.splitAt (head : ListNode) (n : Nat) : Option (ListNode × ListNode) :=
  if n == 0 then
    none
  else
    let firstPartEndOpt := head.get? (n - 1)
    match firstPartEndOpt with
    | none => none
    | some firstPartEnd =>
      let secondPartHeadOpt := firstPartEnd.next
      match secondPartHeadOpt with
      | none => none
      | some secondPartHead =>
        some (head, secondPartHead)

-- Main function definitions
def isPalindrome (head : ListNode) (h_precond : isPalindrome_precond head) : Bool :=
  -- !benchmark @start code
  let len := head.length
  if len ≤ 1 then
    true
  else
    let midIdx := len / 2
    let secondHalfStartOpt := head.get? midIdx
    match secondHalfStartOpt with
    | none => false
    | some secondHalfStart =>
      let reversedSecondHalf := secondHalfStart.reverse
      let vals := head.values
      let firstHalfVals := vals.take midIdx
      let secondHalfVals := vals.drop midIdx
      let adjustedSecondHalfVals := if len % 2 == 1 then secondHalfVals.tail! else secondHalfVals
      let reversedAdjustedSecondHalfVals := adjustedSecondHalfVals.reverse
      firstHalfVals == reversedAdjustedSecondHalfVals
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def isPalindrome_postcond (head : ListNode) (result: Bool) (h_precond : isPalindrome_precond head) : Prop :=
  -- !benchmark @start postcond
  result = head.values.isPalindrome
  -- !benchmark @end postcond

-- Proof content
theorem isPalindrome_postcond_satisfied (head: ListNode) (h_precond : isPalindrome_precond head) :
    isPalindrome_postcond head (isPalindrome head h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof