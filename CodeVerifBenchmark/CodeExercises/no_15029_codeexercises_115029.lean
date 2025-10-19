import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_of_nested_lists_precond (lists : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def sum_of_nested_lists (lists : List (List Nat)) (h_precond : sum_of_nested_lists_precond lists) : Nat :=
  -- !benchmark @start code
  let flattened := lists.foldl (λ acc l => acc ++ l) []
  flattened.foldl (λ acc x => acc + x) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def flatten (lists : List (List Nat)) : List Nat :=
  lists.foldl (λ acc l => acc ++ l) []

-- Postcondition definitions
@[reducible, simp]
def sum_of_nested_lists_postcond (lists : List (List Nat)) (result: Nat) (h_precond : sum_of_nested_lists_precond lists) : Prop :=
  -- !benchmark @start postcond
  result = (flatten lists).sum
  -- !benchmark @end postcond


-- Proof content
theorem sum_of_nested_lists_postcond_satisfied (lists: List (List Nat)) (h_precond : sum_of_nested_lists_precond lists) :
    sum_of_nested_lists_postcond lists (sum_of_nested_lists lists h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof