import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (article : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_duplicates (article : List String) (h_precond : remove_duplicates_precond (article)) : List String :=
  -- !benchmark @start code
  List.dedup article
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_postcond_aux (l : List String) : List String :=
  l.dedup

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (article : List String) (result: List String) (h_precond : remove_duplicates_precond (article)) : Prop :=
  -- !benchmark @start postcond
  result = remove_duplicates_postcond_aux article ∧
  ∀ (s : String), s ∈ result → s ∈ article ∧
  ∀ (i j : Nat), i < j → j < result.length → result[i]! = result[j]! → i = j
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (article: List String) (h_precond : remove_duplicates_precond (article)) :
    remove_duplicates_postcond (article) (remove_duplicates (article) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

