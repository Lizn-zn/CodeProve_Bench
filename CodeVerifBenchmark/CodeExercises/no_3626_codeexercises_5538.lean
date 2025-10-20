import Mathlib

namespace no_3626_codeexercises_5538


-- Precondition definitions
@[reducible, simp]
def create_tuple_precond (complete_list : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def create_tuple (complete_list : List (List Nat)) (h_precond : create_tuple_precond (complete_list)) : List Nat :=
  -- !benchmark @start code
  match complete_list with
  | [] => []
  | hd::tl => 
    List.foldl (λ acc list => 
      List.filter (λ x => List.elem x list) acc) hd tl
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_elements (lists : List (List Nat)) : List Nat :=
  match lists with
  | [] => []
  | hd::tl => List.foldl (λ acc list => List.filter (λ x => List.elem x list) acc) hd tl

def is_common_element (lists : List (List Nat)) (x : Nat) : Prop :=
  ∀ (l : List Nat), l ∈ lists → x ∈ l

-- Postcondition definitions
@[reducible, simp]
def create_tuple_postcond (complete_list : List (List Nat)) (result: List Nat) (h_precond : create_tuple_precond (complete_list)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ is_common_element complete_list x
  -- !benchmark @end postcond


-- Proof content
theorem create_tuple_postcond_satisfied (complete_list: List (List Nat)) (h_precond : create_tuple_precond (complete_list)) :
    create_tuple_postcond (complete_list) (create_tuple (complete_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3626_codeexercises_5538