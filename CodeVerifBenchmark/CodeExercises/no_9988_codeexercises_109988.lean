import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_duplicates_precond (nurse : String) (patients : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def remove_duplicates (nurse : String) (patients : List String) (h_precond : remove_duplicates_precond (nurse) (patients)) : List String :=
  -- !benchmark @start code
  patients.dedup
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def remove_duplicates_postcond_aux (l : List String) : Prop :=
  ∀ (x : String), x ∈ l → List.count x l = 1

-- Postcondition definitions
@[reducible, simp]
def remove_duplicates_postcond (nurse : String) (patients : List String) (result: List String) (h_precond : remove_duplicates_precond (nurse) (patients)) : Prop :=
  -- !benchmark @start postcond
  result = patients.dedup ∧ remove_duplicates_postcond_aux result
  -- !benchmark @end postcond


-- Proof content
theorem remove_duplicates_postcond_satisfied (nurse: String) (patients: List String) (h_precond : remove_duplicates_precond (nurse) (patients)) :
    remove_duplicates_postcond (nurse) (patients) (remove_duplicates (nurse) (patients) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

