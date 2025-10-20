import Mathlib

namespace no_85365_codeexercises_185365


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def create_merged_dictionary_precond (dict1 : List (String × String)) (dict2 : List (String × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Auxiliary function to find common keys between two dictionaries
def common_keys (dict1 dict2 : List (String × String)) : List String :=
  let keys1 := dict1.map Prod.fst
  let keys2 := dict2.map Prod.fst
  keys1.filter (λ k => keys2.contains k)

-- Auxiliary function to get value from dictionary by key
def get_value_from_dict (k : String) (dict : List (String × String)) : Option String :=
  dict.lookup k

-- Main function definitions
def create_merged_dictionary (dict1 : List (String × String)) (dict2 : List (String × String)) (h_precond : create_merged_dictionary_precond dict1 dict2) : List (String × String) :=
  -- !benchmark @start code
  let common := common_keys dict1 dict2
  common.filterMap (λ k => 
    match get_value_from_dict k dict1, get_value_from_dict k dict2 with
    | some v1, some v2 => some (k, v1 ++ v2)
    | _, _ => none
  )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Auxiliary function to check if a key exists in a list of key-value pairs
def has_key (k : String) (dict : List (String × String)) : Prop :=
  ∃ (v : String), (k, v) ∈ dict

-- Auxiliary function to get the value for a key in a list of key-value pairs
def get_value (k : String) (dict : List (String × String)) : Option String :=
  match dict.lookup k with
  | some v => some v
  | none => none

-- Auxiliary function to check if a key is in both dictionaries
def key_in_both (k : String) (dict1 dict2 : List (String × String)) : Prop :=
  has_key k dict1 ∧ has_key k dict2

-- Postcondition definitions
@[reducible, simp]
def create_merged_dictionary_postcond (dict1 : List (String × String)) (dict2 : List (String × String)) (result: List (String × String)) (h_precond : create_merged_dictionary_precond dict1 dict2) : Prop :=
  -- !benchmark @start postcond
  ∀ (k : String) (v : String), 
    (k, v) ∈ result ↔ 
      (∃ (v1 v2 : String), 
        (k, v1) ∈ dict1 ∧ 
        (k, v2) ∈ dict2 ∧ 
        v = v1 ++ v2) ∧
      (∀ (k' : String), k' ∈ (result.map Prod.fst) → key_in_both k' dict1 dict2)
  -- !benchmark @end postcond


-- Proof content
theorem create_merged_dictionary_postcond_satisfied (dict1: List (String × String)) (dict2: List (String × String)) (h_precond : create_merged_dictionary_precond dict1 dict2) :
    create_merged_dictionary_postcond dict1 dict2 (create_merged_dictionary dict1 dict2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_85365_codeexercises_185365