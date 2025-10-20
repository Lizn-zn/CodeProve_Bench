import Mathlib

namespace no_86881_codeexercises_186881


-- Precondition definitions
@[reducible, simp]
def compute_average_age_precond (patients : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def compute_average_age_total_age (patients : List (String × Nat)) : Nat :=
  patients.foldl (fun sum (_, age) => sum + age) 0

def compute_average_age_count (patients : List (String × Nat)) : Nat :=
  patients.length

-- Main function definitions
def compute_average_age (patients : List (String × Nat)) (h_precond : compute_average_age_precond patients) : Float :=
  -- !benchmark @start code
  let total_age := compute_average_age_total_age patients
  let count := compute_average_age_count patients
  if h : count > 0 then
    (Float.ofNat total_age) / (Float.ofNat count)
  else
    0.0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def compute_average_age_total_age_post (patients : List (String × Nat)) : Nat :=
  patients.foldl (fun sum (_, age) => sum + age) 0

def compute_average_age_count_post (patients : List (String × Nat)) : Nat :=
  patients.length

-- Postcondition definitions
@[reducible, simp]
def compute_average_age_postcond (patients : List (String × Nat)) (result: Float) (h_precond : compute_average_age_precond patients) : Prop :=
  -- !benchmark @start postcond
  let total_age := compute_average_age_total_age_post patients
  let count := compute_average_age_count_post patients
  count > 0 ∧ result = (Float.ofNat total_age) / (Float.ofNat count)
  -- !benchmark @end postcond


-- Proof content
theorem compute_average_age_postcond_satisfied (patients: List (String × Nat)) (h_precond : compute_average_age_precond patients) :
    compute_average_age_postcond patients (compute_average_age patients h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_86881_codeexercises_186881