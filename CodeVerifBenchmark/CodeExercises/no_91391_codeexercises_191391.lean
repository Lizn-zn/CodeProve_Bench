import Mathlib

-- Precondition definitions
@[reducible, simp]
def remove_common_items_precond (dictionary1 : List (String × Nat)) (dictionary2 : List (String × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for the implementation

-- Main function definitions
def remove_common_items (dictionary1 : List (String × Nat)) (dictionary2 : List (String × Nat)) (h_precond : remove_common_items_precond (dictionary1) (dictionary2)) : List (String × Nat) :=
  -- !benchmark @start code
  let keys1 := dictionary1.map Prod.fst
  let keys2 := dictionary2.map Prod.fst
  let common_keys := keys1.filter (λ k => k ∈ keys2)
  dictionary1.filter (λ x => ¬(x.1 ∈ common_keys)) ++ dictionary2.filter (λ x => ¬(x.1 ∈ common_keys))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique_keys (dict : List (String × Nat)) : Prop :=
  ∀ (k : String), (dict.filter (λ x => x.1 = k)).length ≤ 1

def get_keys (dict : List (String × Nat)) : List String :=
  dict.map Prod.fst

def remove_common_keys (dict1 dict2 : List (String × Nat)) : List (String × Nat) :=
  let keys1 := get_keys dict1
  let keys2 := get_keys dict2
  let common_keys := keys1.filter (λ k => k ∈ keys2)
  dict1.filter (λ x => ¬(x.1 ∈ common_keys)) ++ dict2.filter (λ x => ¬(x.1 ∈ common_keys))

-- Postcondition definitions
@[reducible, simp]
def remove_common_items_postcond (dictionary1 : List (String × Nat)) (dictionary2 : List (String × Nat)) (result: List (String × Nat)) (h_precond : remove_common_items_precond (dictionary1) (dictionary2)) : Prop :=
  -- !benchmark @start postcond
  is_unique_keys dictionary1 ∧ is_unique_keys dictionary2 ∧
  is_unique_keys result ∧
  remove_common_keys dictionary1 dictionary2 = result
  -- !benchmark @end postcond


-- Proof content
theorem remove_common_items_postcond_satisfied (dictionary1: List (String × Nat)) (dictionary2: List (String × Nat)) (h_precond : remove_common_items_precond (dictionary1) (dictionary2)) :
    remove_common_items_postcond (dictionary1) (dictionary2) (remove_common_items (dictionary1) (dictionary2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

