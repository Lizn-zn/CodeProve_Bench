import Mathlib

namespace no_25791_codeexercises_125791


-- Precondition definitions
@[reducible, simp]
def get_common_items_precond (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def get_common_items (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) (h_precond : get_common_items_precond (dict1) (dict2)) : List (Prod String Nat) :=
  -- !benchmark @start code
  let rec loop (remaining : List (Prod String Nat)) (acc : List (Prod String Nat)) : List (Prod String Nat) :=
    match remaining with
    | [] => acc
    | item :: rest =>
      if item ∈ dict2 then
        loop rest (item :: acc)
      else
        loop rest acc
  loop dict1 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_item (item : Prod String Nat) (dict1 dict2 : List (Prod String Nat)) : Prop :=
  item ∈ dict1 ∧ item ∈ dict2

def all_common_items (dict1 dict2 : List (Prod String Nat)) : List (Prod String Nat) :=
  dict1.filter (λ item => item ∈ dict2)

-- Postcondition definitions
@[reducible, simp]
def get_common_items_postcond (dict1 : List (Prod String Nat)) (dict2 : List (Prod String Nat)) (result: List (Prod String Nat)) (h_precond : get_common_items_precond (dict1) (dict2)) : Prop :=
  -- !benchmark @start postcond
  result = all_common_items dict1 dict2 ∧
  ∀ item : Prod String Nat, item ∈ result ↔ is_common_item item dict1 dict2
  -- !benchmark @end postcond


-- Proof content
theorem get_common_items_postcond_satisfied (dict1: List (Prod String Nat)) (dict2: List (Prod String Nat)) (h_precond : get_common_items_precond (dict1) (dict2)) :
    get_common_items_postcond (dict1) (dict2) (get_common_items (dict1) (dict2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_25791_codeexercises_125791