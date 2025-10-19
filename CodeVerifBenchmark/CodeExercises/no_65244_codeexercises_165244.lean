import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_specific_element_precond (tuples : List (List α)) (element : α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_specific_element [DecidableEq α] (tuples : List (List α)) (element : α) (h_precond : find_specific_element_precond (tuples) (element)) : Int :=
  -- !benchmark @start code
  let rec find_specific_element_helper (tuples : List (List α)) (element : α) (current_index : Nat) : Int :=
    match tuples with
    | [] => -1
    | tuple :: rest =>
      if List.elem element tuple then
        Int.ofNat current_index
      else
        find_specific_element_helper rest element (current_index + 1)
  find_specific_element_helper tuples element 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_specific_element_aux [DecidableEq α] (tuples : List (List α)) (element : α) : Int :=
  match tuples.findIdx? (λ t => List.elem element t) with
  | some idx => Int.ofNat idx
  | none => -1

-- Postcondition definitions
@[reducible, simp]
def find_specific_element_postcond [DecidableEq α] (tuples : List (List α)) (element : α) (result: Int) (h_precond : find_specific_element_precond (tuples) (element)) : Prop :=
  -- !benchmark @start postcond
  result = find_specific_element_aux tuples element
  -- !benchmark @end postcond


-- Proof content
theorem find_specific_element_postcond_satisfied [DecidableEq α] (tuples: List (List α)) (element: α) (h_precond : find_specific_element_precond (tuples) (element)) :
    find_specific_element_postcond (tuples) (element) (find_specific_element (tuples) (element) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof