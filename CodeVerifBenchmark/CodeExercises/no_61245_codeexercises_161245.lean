import Mathlib

namespace no_61245_codeexercises_161245


-- Precondition definitions
@[reducible, simp]
def create_patient_tuples_precond (patient_names : List String) (patient_ages : List Nat) : Prop :=
  -- !benchmark @start precond
  patient_names.length = patient_ages.length
  -- !benchmark @end precond


-- Main function definitions
def create_patient_tuples (patient_names : List String) (patient_ages : List Nat) (h_precond : create_patient_tuples_precond (patient_names) (patient_ages)) : List (String × Nat) :=
  -- !benchmark @start code
  List.zip patient_names patient_ages
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_patient_tuples_postcond (patient_names : List String) (patient_ages : List Nat) (result: List (String × Nat)) (h_precond : create_patient_tuples_precond (patient_names) (patient_ages)) : Prop :=
  -- !benchmark @start postcond
  result.length = patient_names.length ∧
  ∀ i : Fin result.length, result[i]! = (patient_names[i]!, patient_ages[i]!)
  -- !benchmark @end postcond


-- Proof content
theorem create_patient_tuples_postcond_satisfied (patient_names: List String) (patient_ages: List Nat) (h_precond : create_patient_tuples_precond (patient_names) (patient_ages)) :
    create_patient_tuples_postcond (patient_names) (patient_ages) (create_patient_tuples (patient_names) (patient_ages) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_61245_codeexercises_161245