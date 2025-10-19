import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_negative_elements_precond (data : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def remove_negative_elements (data : List Int) (h_precond : remove_negative_elements_precond (data)) : List Int :=
  -- !benchmark @start code
  match data with
  | [] => []
  | x :: xs => 
    if x ≥ 0 then
      x :: remove_negative_elements xs h_precond
    else
      remove_negative_elements xs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_non_negative (x : Int) : Prop := x ≥ 0

-- Postcondition definitions
@[reducible, simp]
def remove_negative_elements_postcond (data : List Int) (result: List Int) (h_precond : remove_negative_elements_precond (data)) : Prop :=
  -- !benchmark @start postcond
  result = data.filter (λ x => x ≥ 0) ∧ ∀ x ∈ result, x ≥ 0
  -- !benchmark @end postcond


-- Proof content
theorem remove_negative_elements_postcond_satisfied (data: List Int) (h_precond : remove_negative_elements_precond (data)) :
    remove_negative_elements_postcond (data) (remove_negative_elements (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

