import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (tuple1 : List Nat) (tuple2 : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if an element is in a list
def elem_in_list (x : Nat) (l : List Nat) : Bool :=
  l.contains x

-- Helper function to filter common elements
def filter_common (l1 l2 : List Nat) : List Nat :=
  l1.filter (λ x => elem_in_list x l2)

-- Helper function to remove duplicates while preserving order
def remove_duplicates : List Nat → List Nat
  | [] => []
  | (x :: xs) => 
    if elem_in_list x xs then
      remove_duplicates xs
    else
      x :: remove_duplicates xs

-- Main function definitions
def find_common_elements (tuple1 : List Nat) (tuple2 : List Nat) (h_precond : find_common_elements_precond (tuple1) (tuple2)) : List Nat :=
  -- !benchmark @start code
  let common := filter_common tuple1 tuple2
  remove_duplicates common
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def CommonElements (tuple1 tuple2 result : List Nat) : Prop :=
  ∀ x, x ∈ result ↔ x ∈ tuple1 ∧ x ∈ tuple2 ∧ result.count x = 1

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (tuple1 : List Nat) (tuple2 : List Nat) (result: List Nat) (h_precond : find_common_elements_precond (tuple1) (tuple2)) : Prop :=
  -- !benchmark @start postcond
  CommonElements tuple1 tuple2 result
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (tuple1: List Nat) (tuple2: List Nat) (h_precond : find_common_elements_precond (tuple1) (tuple2)) :
    find_common_elements_postcond (tuple1) (tuple2) (find_common_elements (tuple1) (tuple2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

