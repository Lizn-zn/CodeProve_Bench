import Mathlib

-- Precondition definitions
@[reducible, simp]
def filter_keys_by_value_precond (dictionary : List (Prod String Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions


-- Main function definitions
def filter_keys_by_value (dictionary : List (Prod String Nat)) (h_precond : filter_keys_by_value_precond dictionary) : List String :=
  -- !benchmark @start code
  let filtered := dictionary.filter (λ (pair : Prod String Nat) => pair.snd ≤ 5)
  filtered.map Prod.fst
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def filter_keys_by_value_postcond (dictionary : List (Prod String Nat)) (result: List String) (h_precond : filter_keys_by_value_precond dictionary) : Prop :=
  -- !benchmark @start postcond
  ∀ (k : String) (v : Nat), (k, v) ∈ dictionary → (k ∈ result ↔ v ≤ 5)
  -- !benchmark @end postcond


-- Proof content
theorem filter_keys_by_value_postcond_satisfied (dictionary: List (Prod String Nat)) (h_precond : filter_keys_by_value_precond dictionary) :
    filter_keys_by_value_postcond dictionary (filter_keys_by_value dictionary h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof