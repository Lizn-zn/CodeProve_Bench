import Mathlib

namespace no_62539_codeexercises_162539


-- Precondition definitions
@[reducible, simp]
def common_schedule_precond (nurse_schedule : List String) (available_shift : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def common_schedule (nurse_schedule : List String) (available_shift : List String) (h_precond : common_schedule_precond (nurse_schedule) (available_shift)) : List String :=
  -- !benchmark @start code
  let all_shifts := nurse_schedule ++ available_shift
  all_shifts.filter (λ shift => 
    (shift ∈ nurse_schedule ∧ shift ∉ available_shift) ∨ (shift ∉ nurse_schedule ∧ shift ∈ available_shift)
  )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_schedule (nurse_schedule available_shift result : List String) : Prop :=
  ∀ (shift : String), shift ∈ result ↔ (shift ∈ nurse_schedule ∧ shift ∉ available_shift) ∨ (shift ∉ nurse_schedule ∧ shift ∈ available_shift)

-- Postcondition definitions
@[reducible, simp]
def common_schedule_postcond (nurse_schedule : List String) (available_shift : List String) (result: List String) (h_precond : common_schedule_precond (nurse_schedule) (available_shift)) : Prop :=
  -- !benchmark @start postcond
  is_common_schedule nurse_schedule available_shift result
  -- !benchmark @end postcond


-- Proof content
theorem common_schedule_postcond_satisfied (nurse_schedule: List String) (available_shift: List String) (h_precond : common_schedule_precond (nurse_schedule) (available_shift)) :
    common_schedule_postcond (nurse_schedule) (available_shift) (common_schedule (nurse_schedule) (available_shift) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_62539_codeexercises_162539