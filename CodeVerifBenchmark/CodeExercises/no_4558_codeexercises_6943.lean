import Mathlib

-- Precondition definitions
@[reducible, simp]
def intersection_of_lists_precond (list1 : List Nat) (list2 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def dedup (l : List Nat) : List Nat :=
  match l with
  | [] => []
  | x :: xs => if x ∈ xs then dedup xs else x :: dedup xs

-- Main function definitions
def intersection_of_lists (list1 : List Nat) (list2 : List Nat) (h_precond : intersection_of_lists_precond (list1) (list2)) : List Nat :=
  -- !benchmark @start code
  let common := list1.filter (λ x => x ∈ list2)
  dedup common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_intersection (list1 list2 result : List Nat) : Prop :=
  ∀ x, x ∈ result ↔ (x ∈ list1 ∧ x ∈ list2) ∧ (result.filter (λ y => y = x)).length = 1

-- Postcondition definitions
@[reducible, simp]
def intersection_of_lists_postcond (list1 : List Nat) (list2 : List Nat) (result: List Nat) (h_precond : intersection_of_lists_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  is_intersection list1 list2 result
  -- !benchmark @end postcond


-- Proof content
theorem intersection_of_lists_postcond_satisfied (list1: List Nat) (list2: List Nat) (h_precond : intersection_of_lists_precond (list1) (list2)) :
    intersection_of_lists_postcond (list1) (list2) (intersection_of_lists (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof