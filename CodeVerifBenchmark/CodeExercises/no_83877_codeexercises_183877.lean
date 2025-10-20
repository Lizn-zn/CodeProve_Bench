import Mathlib

namespace no_83877_codeexercises_183877


-- Precondition definitions
@[reducible, simp]
def intersection_precond (nested_list : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the intersection of two lists
def intersect_lists (l1 l2 : List Nat) : List Nat :=
  l1.filter (λ x => l2.contains x)

-- Helper function to compute the intersection of all lists in a list
def intersect_all (lists : List (List Nat)) : List Nat :=
  match lists with
  | [] => []
  | [x] => x
  | hd::tl => List.foldl intersect_lists hd tl

-- Main function definitions
def intersection (nested_list : List (List Nat)) (h_precond : intersection_precond (nested_list)) : List Nat :=
  -- !benchmark @start code
  match nested_list with
  | [] => []
  | hd::tl => 
    let common := List.foldl (λ acc lst => acc.filter (λ x => lst.contains x)) hd tl
    common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def intersection_set (lists : List (List Nat)) : Set Nat :=
  match lists with
  | [] => Set.univ
  | hd::tl => List.toFinset hd ∩ intersection_set tl

def is_intersection (lists : List (List Nat)) (result : List Nat) : Prop :=
  List.toFinset result = intersection_set lists

-- Postcondition definitions
@[reducible, simp]
def intersection_postcond (nested_list : List (List Nat)) (result: List Nat) (h_precond : intersection_precond (nested_list)) : Prop :=
  -- !benchmark @start postcond
  is_intersection nested_list result
  -- !benchmark @end postcond


-- Proof content
theorem intersection_postcond_satisfied (nested_list: List (List Nat)) (h_precond : intersection_precond (nested_list)) :
    intersection_postcond (nested_list) (intersection (nested_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_83877_codeexercises_183877