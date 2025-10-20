import Mathlib

namespace no_4617_codeexercises_7035


-- Precondition definitions
@[reducible, simp]
def get_common_elements_precond (list1 : List α) (list2 : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def get_common_elements [DecidableEq α] (list1 : List α) (list2 : List α) (h_precond : get_common_elements_precond (list1) (list2)) : List α :=
  -- !benchmark @start code
  let rec find_common (l1 : List α) (l2 : List α) : List α :=
    match l1 with
    | [] => []
    | x :: xs =>
      if List.elem x l2 then
        x :: find_common xs l2
      else
        find_common xs l2
  find_common list1 list2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_common_element (x : α) (list1 list2 : List α) : Prop :=
  x ∈ list1 ∧ x ∈ list2

def all_common_elements (list1 list2 : List α) : Set α :=
  {x | x ∈ list1 ∧ x ∈ list2}

-- Postcondition definitions
@[reducible, simp]
def get_common_elements_postcond (list1 : List α) (list2 : List α) (result: List α) (h_precond : get_common_elements_precond (list1) (list2)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, x ∈ result ↔ x ∈ list1 ∧ x ∈ list2
  -- !benchmark @end postcond


-- Proof content
theorem get_common_elements_postcond_satisfied [DecidableEq α] (list1: List α) (list2: List α) (h_precond : get_common_elements_precond (list1) (list2)) :
    get_common_elements_postcond (list1) (list2) (get_common_elements (list1) (list2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4617_codeexercises_7035