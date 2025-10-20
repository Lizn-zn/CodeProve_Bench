import Mathlib

namespace no_22_leetcode_23


-- Precondition auxiliary definitions
def SortedList : List Int → Prop
  | [] => True
  | [_] => True
  | a :: b :: rest => a ≤ b ∧ SortedList (b :: rest)

-- Precondition definitions
@[reducible, simp]
def mergeKLists_precond (lists : List (List Int)) : Prop :=
  -- !benchmark @start precond
  ∀ l ∈ lists, SortedList l
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Merge two sorted lists into one sorted list -/
def mergeTwoSortedLists : List Int → List Int → List Int
  | [], ys => ys
  | xs, [] => xs
  | x :: xs, y :: ys =>
    if x ≤ y then
      x :: mergeTwoSortedLists xs (y :: ys)
    else
      y :: mergeTwoSortedLists (x :: xs) ys

/-- Flatten a list of lists and sort the result -/
def flattenAndSort (lists : List (List Int)) : List Int :=
  let flattened := lists.flatMap id
  flattened.mergeSort

-- Main function definitions
def mergeKLists (lists : List (List Int)) (h_precond : mergeKLists_precond (lists)) : List Int :=
  -- !benchmark @start code
  flattenAndSort lists
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for the postcondition

-- Postcondition definitions
@[reducible, simp]
def mergeKLists_postcond (lists : List (List Int)) (result: List Int) (h_precond : mergeKLists_precond (lists)) : Prop :=
  -- !benchmark @start postcond
  SortedList result ∧
    let counts := lists.flatMap id
    let resultCounts := result
    -- Check that the multiset of elements is preserved
    ∀ x : Int, (counts.filter (· = x)).length = (resultCounts.filter (· = x)).length
  -- !benchmark @end postcond


-- Proof content
theorem mergeKLists_postcond_satisfied (lists: List (List Int)) (h_precond : mergeKLists_precond (lists)) :
    mergeKLists_postcond (lists) (mergeKLists (lists) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_22_leetcode_23