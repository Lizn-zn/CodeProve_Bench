import Mathlib

namespace no_40116_codeexercises_140116


-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (graphic_designers : List (List String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to remove duplicates from a list while preserving order
def remove_dups_from_list (l : List String) : List String :=
  l.foldr (λ x acc => if x ∈ acc then acc else x :: acc) []

def flatten (lists : List (List String)) : List String :=
  lists.foldl (λ acc l => acc ++ l) []

-- Main function definitions
def remove_duplicates (graphic_designers : List (List String)) (h_precond : remove_duplicates_precond graphic_designers) : List String :=
  -- !benchmark @start code
  -- First, flatten the nested list into a single list
  let flattened := flatten graphic_designers
  -- Then remove duplicates while preserving the order of first occurrence
  remove_dups_from_list flattened
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique (l : List String) : Prop :=
  ∀ x, x ∈ l → l.count x = 1

def same_elements (l1 l2 : List String) : Prop :=
  ∀ x, x ∈ l1 ↔ x ∈ l2

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (graphic_designers : List (List String)) (result: List String) (h_precond : remove_duplicates_precond graphic_designers) : Prop :=
  -- !benchmark @start postcond
  let flattened := flatten graphic_designers
  is_unique result ∧ same_elements result flattened
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (graphic_designers: List (List String)) (h_precond : remove_duplicates_precond graphic_designers) :
    remove_duplicates_postcond graphic_designers (remove_duplicates graphic_designers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_40116_codeexercises_140116