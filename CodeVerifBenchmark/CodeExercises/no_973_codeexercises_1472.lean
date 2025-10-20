import Mathlib

namespace no_973_codeexercises_1472


-- Precondition definitions
@[reducible, simp]
def intersection_of_set_and_list_precond (set1 : Set Nat) (list1 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def list_to_set (list1 : List Nat) : Set Nat := λ x => list1.contains x

-- Main function definitions
def intersection_of_set_and_list (set1 : Set Nat) (list1 : List Nat) (h_precond : intersection_of_set_and_list_precond (set1) (list1)) : Set Nat :=
  -- !benchmark @start code
  λ x => set1 x ∧ list1.contains x
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def list_to_set_post (list1 : List Nat) : Set Nat := λ x => list1.contains x

-- Postcondition definitions
@[reducible, simp]
def intersection_of_set_and_list_postcond (set1 : Set Nat) (list1 : List Nat) (result: Set Nat) (h_precond : intersection_of_set_and_list_precond (set1) (list1)) : Prop :=
  -- !benchmark @start postcond
  result = set1 ∩ (list_to_set_post list1)
  -- !benchmark @end postcond


-- Proof content
theorem intersection_of_set_and_list_postcond_satisfied (set1: Set Nat) (list1: List Nat) (h_precond : intersection_of_set_and_list_precond (set1) (list1)) :
    intersection_of_set_and_list_postcond (set1) (list1) (intersection_of_set_and_list (set1) (list1) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_973_codeexercises_1472