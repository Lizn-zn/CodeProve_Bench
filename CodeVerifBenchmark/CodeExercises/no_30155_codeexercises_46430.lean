import Mathlib

namespace no_30155_codeexercises_46430


-- Precondition definitions
@[reducible, simp]
def veterinarian_records_precond (vet_records : List (String × ℂ)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
noncomputable def perform_operations (c : ℂ) : ℂ :=
  let add := c + c
  let sub := c - c
  let mul := c * c
  let div := if c ≠ 0 then c / c else 0
  add + sub + mul + div

-- Main function definitions
noncomputable def veterinarian_records (vet_records : List (String × ℂ)) (h_precond : veterinarian_records_precond (vet_records)) : List (String × ℂ) :=
  -- !benchmark @start code
  List.map (λ (record : String × ℂ) => 
    let (name, c) := record
    let op_result := perform_operations c
    (name, op_result)) vet_records
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (perform_operations is now defined above and shared between code and postcondition)

-- Postcondition definitions
@[reducible, simp]
def veterinarian_records_postcond (vet_records : List (String × ℂ)) (result: List (String × ℂ)) (h_precond : veterinarian_records_precond (vet_records)) : Prop :=
  -- !benchmark @start postcond
  ∀ (name : String) (c : ℂ), (name, c) ∈ vet_records → ∃ (op_result : ℂ), (name, op_result) ∈ result ∧ op_result = perform_operations c
  -- !benchmark @end postcond


-- Proof content
theorem veterinarian_records_postcond_satisfied (vet_records: List (String × ℂ)) (h_precond : veterinarian_records_precond (vet_records)) :
    veterinarian_records_postcond (vet_records) (veterinarian_records (vet_records) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_30155_codeexercises_46430