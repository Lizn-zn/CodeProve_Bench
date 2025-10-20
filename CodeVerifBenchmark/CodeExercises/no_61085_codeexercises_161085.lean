import Mathlib

namespace no_61085_codeexercises_161085


-- Precondition definitions
@[reducible, simp]
def index_values_precond (data : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def index_values (data : List Nat) (h_precond : index_values_precond (data)) : Set Nat :=
  -- !benchmark @start code
  Id.run do
    let mut result : Set Nat := {}
    for i in List.range data.length do
      if data[i]! ≥ i then
        result := result.insert i
    return result
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def index_values_postcond (data : List Nat) (result: Set Nat) (h_precond : index_values_precond (data)) : Prop :=
  -- !benchmark @start postcond
  ∀ i : Nat, i ∈ result ↔ (i < data.length ∧ data[i]! ≥ i)
  -- !benchmark @end postcond


-- Proof content
theorem index_values_postcond_satisfied (data: List Nat) (h_precond : index_values_precond (data)) :
    index_values_postcond (data) (index_values (data) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_61085_codeexercises_161085