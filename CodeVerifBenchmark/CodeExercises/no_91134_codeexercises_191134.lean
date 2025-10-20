import Mathlib

namespace no_91134_codeexercises_191134


-- Precondition definitions
@[reducible, simp]
def set_intersection_precond (nested_sets : List (Set Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def set_intersection (nested_sets : List (Set Nat)) (h_precond : set_intersection_precond (nested_sets)) : Set Nat :=
  -- !benchmark @start code
  match nested_sets with
  | [] => Set.univ
  | hd::tl => List.foldl Set.inter hd tl
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def intersection_of_sets (sets : List (Set Nat)) : Set Nat :=
  match sets with
  | [] => Set.univ
  | hd::tl => List.foldl Set.inter hd tl

-- Postcondition definitions
@[reducible, simp]
def set_intersection_postcond (nested_sets : List (Set Nat)) (result: Set Nat) (h_precond : set_intersection_precond (nested_sets)) : Prop :=
  -- !benchmark @start postcond
  result = intersection_of_sets nested_sets
  -- !benchmark @end postcond


-- Proof content
theorem set_intersection_postcond_satisfied (nested_sets: List (Set Nat)) (h_precond : set_intersection_precond (nested_sets)) :
    set_intersection_postcond (nested_sets) (set_intersection (nested_sets) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_91134_codeexercises_191134