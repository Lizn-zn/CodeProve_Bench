import Mathlib

namespace no_17223_codeexercises_117223


-- Precondition definitions
@[reducible, simp]
def create_intersection_dictionary_precond (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def get_value_for_key_in_dict (key : String) (dict : List (Prod String Nat)) : Option Nat :=
  match dict.find? (λ p => p.1 = key) with
  | some p => some p.2
  | none => none

-- Main function definitions
def create_intersection_dictionary (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) (h_precond : create_intersection_dictionary_precond dict1 dict2) : List (Prod String (Prod Nat Nat)) :=
  -- !benchmark @start code
  let common_keys := dict1.filterMap (λ p => 
      if dict2.any (λ q => q.1 = p.1) then some p.1 else none)
  common_keys.filterMap (λ k => 
      match get_value_for_key_in_dict k dict1, get_value_for_key_in_dict k dict2 with
      | some v1, some v2 => some (Prod.mk k (Prod.mk v1 v2))
      | _, _ => none)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_key_in_dict (key : String) (dict : List (Prod String Nat)) : Bool :=
  dict.any (λ p => p.1 = key)

def get_value_for_key (key : String) (dict : List (Prod String Nat)) : Option Nat :=
  match dict.find? (λ p => p.1 = key) with
  | some p => some p.2
  | none => none

-- Postcondition definitions
@[reducible, simp]
def create_intersection_dictionary_postcond (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) (result: List (Prod String (Prod Nat Nat))) (h_precond : create_intersection_dictionary_precond dict1 dict2) : Prop :=
  -- !benchmark @start postcond
  ∀ (k : String) (v1 v2 : Nat), 
    (Prod.mk k (Prod.mk v1 v2)) ∈ result ↔ 
    (Prod.mk k v1) ∈ dict1 ∧ (Prod.mk k v2) ∈ dict2
  -- !benchmark @end postcond


-- Proof content
theorem create_intersection_dictionary_postcond_satisfied (dict1: List (Prod String Nat)) (dict2: List (Prod String Nat)) (h_precond : create_intersection_dictionary_precond dict1 dict2) :
    create_intersection_dictionary_postcond dict1 dict2 (create_intersection_dictionary dict1 dict2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_17223_codeexercises_117223