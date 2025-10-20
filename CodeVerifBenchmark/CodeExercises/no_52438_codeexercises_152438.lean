import Mathlib

namespace no_52438_codeexercises_152438


-- Precondition definitions
@[reducible, simp]
def modify_tuple_precond  : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this task

-- Main function definitions
def modify_tuple  (h_precond : modify_tuple_precond) : String × Nat × List String :=
  -- !benchmark @start code
  let physician_info : String × Nat × List String := ("Dr. John Smith", 35, ["Internal Medicine", "Pediatrics"])
  let (original_name, original_age, original_specialties) := physician_info
  let new_name := "Dr. Jane Doe"
  let new_age := 2 * original_age
  let new_specialties := "Cardiology" :: original_specialties
  (new_name, new_age, new_specialties)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def modify_tuple_postcond  (result: String × Nat × List String) (h_precond : modify_tuple_precond) : Prop :=
  -- !benchmark @start postcond
  let (name, age, specialties) := result
  name = "Dr. Jane Doe" ∧ 
  ∃ (original_age : Nat), age = 2 * original_age ∧ 
  "Cardiology" ∈ specialties
  -- !benchmark @end postcond


-- Proof content
theorem modify_tuple_postcond_satisfied (h_precond : modify_tuple_precond) :
    modify_tuple_postcond (modify_tuple h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_52438_codeexercises_152438