import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_keys_precond (d1 : List (Prod String α)) (d2 : List (Prod String β)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a key exists in a dictionary
def has_key (k : String) (dict : List (Prod String α)) : Bool :=
  dict.any (λ p => p.fst == k)

-- Helper function to get distinct keys from a dictionary
def get_distinct_keys (dict : List (Prod String α)) : List String :=
  dict.map Prod.fst |>.eraseDup

-- Main function definitions
def find_common_keys (d1 : List (Prod String α)) (d2 : List (Prod String β)) (h_precond : find_common_keys_precond (d1) (d2)) : List String :=
  -- !benchmark @start code
  let keys1 := get_distinct_keys d1
  let keys2 := get_distinct_keys d2
  keys1.filter (λ k => has_key k d2)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def distinct_keys (dict : List (Prod String α)) : List String :=
  dict.map Prod.fst |>.eraseDup

def is_key_in_dict (k : String) (dict : List (Prod String α)) : Prop :=
  ∃ (v : α), (k, v) ∈ dict

-- Postcondition definitions
@[reducible, simp]
def find_common_keys_postcond (d1 : List (Prod String α)) (d2 : List (Prod String β)) (result: List String) (h_precond : find_common_keys_precond (d1) (d2)) : Prop :=
  -- !benchmark @start postcond
  ∀ k, k ∈ result ↔ (is_key_in_dict k d1 ∧ is_key_in_dict k d2) ∧
    (∀ k', k' ∈ result → k' = k → k ∈ distinct_keys d1 ∧ k ∈ distinct_keys d2)
  -- !benchmark @end postcond


-- Proof content
theorem find_common_keys_postcond_satisfied (d1: List (Prod String α)) (d2: List (Prod String β)) (h_precond : find_common_keys_precond (d1) (d2)) :
    find_common_keys_postcond (d1) (d2) (find_common_keys (d1) (d2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

