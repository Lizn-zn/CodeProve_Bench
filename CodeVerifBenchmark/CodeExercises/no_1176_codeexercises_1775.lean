import Mathlib

-- Precondition definitions
@[reducible, simp]
def copy_set_to_list_precond (set_elements : Set α) : Prop :=
  -- !benchmark @start precond
  Set.Finite set_elements
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple conversion

-- Main function definitions
noncomputable def copy_set_to_list (set_elements : Set α) (h_precond : copy_set_to_list_precond (set_elements)) : List α :=
  -- !benchmark @start code
  -- Convert the set to a list by using Set.elements
  have h_finite : Set.Finite set_elements := h_precond
  h_finite.toFinset.toList
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def copy_set_to_list_postcond (set_elements : Set α) (result: List α) (h_precond : copy_set_to_list_precond (set_elements)) : Prop :=
  -- !benchmark @start postcond
  ∀ (x : α), x ∈ set_elements ↔ x ∈ result
  -- !benchmark @end postcond


-- Proof content
theorem copy_set_to_list_postcond_satisfied (set_elements: Set α) (h_precond : copy_set_to_list_precond (set_elements)) :
    copy_set_to_list_postcond (set_elements) (copy_set_to_list (set_elements) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof