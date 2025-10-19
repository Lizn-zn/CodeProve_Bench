import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_total_precond (current : List Int) : Prop :=
  -- !benchmark @start precond
  ∀ (r : Int), r ∈ current → r < 0
  -- !benchmark @end precond


-- Main function definitions
def calculate_total (current : List Int) (h_precond : calculate_total_precond (current)) : Int :=
  -- !benchmark @start code
  match current with
    | [] => 0
    | h::t => h + calculate_total t (by
        intro r hr
        apply h_precond r
        simp [hr])
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_total_postcond (current : List Int) (result: Int) (h_precond : calculate_total_precond (current)) : Prop :=
  -- !benchmark @start postcond
  result = current.foldl (λ acc r => acc + r) 0
  -- !benchmark @end postcond


-- Proof content
theorem calculate_total_postcond_satisfied (current: List Int) (h_precond : calculate_total_precond (current)) :
    calculate_total_postcond (current) (calculate_total (current) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

