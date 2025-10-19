import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (list1 : List (List Nat)) (list2 : List (List Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def flatten (lists : List (List Nat)) : List Nat :=
  lists.foldl (λ acc l => acc ++ l) []

def find_common_elements_aux (list1 : List (List Nat)) (list2 : List (List Nat)) : List Nat :=
  let flat1 := flatten list1
  let flat2 := flatten list2
  flat1.filter (λ x => x ∈ flat2) |>.eraseDups

-- Main function definitions
def find_common_elements (list1 : List (List Nat)) (list2 : List (List Nat)) (h_precond : find_common_elements_precond (list1) (list2)) : List Nat :=
  -- !benchmark @start code
  find_common_elements_aux list1 list2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def flatten_post (lists : List (List Nat)) : List Nat :=
  lists.foldl (λ acc l => acc ++ l) []

def is_common_element (x : Nat) (list1 list2 : List (List Nat)) : Prop :=
  x ∈ flatten_post list1 ∧ x ∈ flatten_post list2

def all_common_elements (list1 list2 : List (List Nat)) : Set Nat :=
  {x | is_common_element x list1 list2}

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (list1 : List (List Nat)) (list2 : List (List Nat)) (result: List Nat) (h_precond : find_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ all_common_elements list1 list2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (list1: List (List Nat)) (list2: List (List Nat)) (h_precond : find_common_elements_precond (list1) (list2)) :
    find_common_elements_postcond (list1) (list2) (find_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof