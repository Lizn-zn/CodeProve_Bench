import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_president_precond (term : Nat) (presidents : List (Nat × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def find_president (term : Nat) (presidents : List (Nat × String)) (h_precond : find_president_precond (term) (presidents)) : String :=
  -- !benchmark @start code
  if presidents.any (λ (t, _) => t = term) then
    "Yes"
  else
    "No"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_president_for_term (term : Nat) (presidents : List (Nat × String)) : Bool :=
  presidents.any (λ (t, _) => t = term)

-- Postcondition definitions
@[reducible, simp]
def find_president_postcond (term : Nat) (presidents : List (Nat × String)) (result: String) (h_precond : find_president_precond (term) (presidents)) : Prop :=
  -- !benchmark @start postcond
  if is_president_for_term term presidents then
    result = "Yes"
  else
    result = "No"
  -- !benchmark @end postcond


-- Proof content
theorem find_president_postcond_satisfied (term: Nat) (presidents: List (Nat × String)) (h_precond : find_president_precond (term) (presidents)) :
    find_president_postcond (term) (presidents) (find_president (term) (presidents) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

