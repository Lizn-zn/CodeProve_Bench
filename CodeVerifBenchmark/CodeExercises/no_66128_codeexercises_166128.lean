import Mathlib

-- Precondition definitions
@[reducible, simp]
def get_patient_data_precond (patients : List (Nat × String × Nat × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def get_patient_data (patients : List (Nat × String × Nat × String)) (h_precond : get_patient_data_precond patients) : List String :=
  -- !benchmark @start code
  let eligible_patients := patients.filter (λ patient => 
    let (_, _, age, diagnosis) := patient
    age > 60 ∧ diagnosis = "Hypertension")
  eligible_patients.map (λ (id, name, age, diagnosis) => name)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_eligible_patient (patient : Nat × String × Nat × String) : Bool :=
  let (_, _, age, diagnosis) := patient
  age > 60 ∧ diagnosis = "Hypertension"

def get_patient_names (patients : List (Nat × String × Nat × String)) : List String :=
  patients.filter is_eligible_patient |>.map (λ (id, name, age, diagnosis) => name)

-- Postcondition definitions
@[reducible, simp]
def get_patient_data_postcond (patients : List (Nat × String × Nat × String)) (result: List String) (h_precond : get_patient_data_precond patients) : Prop :=
  -- !benchmark @start postcond
  result = get_patient_names patients
  -- !benchmark @end postcond


-- Proof content
theorem get_patient_data_postcond_satisfied (patients: List (Nat × String × Nat × String)) (h_precond : get_patient_data_precond patients) :
    get_patient_data_postcond patients (get_patient_data patients h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof