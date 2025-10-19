import Mathlib

-- Precondition definitions
@[reducible, simp]
def filter_elements_by_indices_precond (arr : Array Int) (index_set : Finset Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
noncomputable def filter_elements_by_indices (arr : Array Int) (index_set : Finset Nat) (h_precond : filter_elements_by_indices_precond (arr) (index_set)) : List Int :=
  -- !benchmark @start code
  let valid_indices := index_set.filter (λ i => i < arr.size)
  (valid_indices.val.map (λ i => arr[i]!)).toList
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def filter_elements_by_indices_postcond (arr : Array Int) (index_set : Finset Nat) (result: List Int) (h_precond : filter_elements_by_indices_precond (arr) (index_set)) : Prop :=
  -- !benchmark @start postcond
  result = ((index_set.filter (λ i => i < arr.size)).val.map (λ i => arr[i]!)).toList
  -- !benchmark @end postcond


-- Proof content
theorem filter_elements_by_indices_postcond_satisfied (arr: Array Int) (index_set: Finset Nat) (h_precond : filter_elements_by_indices_precond (arr) (index_set)) :
    filter_elements_by_indices_postcond (arr) (index_set) (filter_elements_by_indices (arr) (index_set) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof