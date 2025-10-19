import Mathlib

-- Precondition definitions
@[reducible, simp]
def append_unique_elements_precond (elements : List String) (new_elements : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def append_unique_elements (elements : List String) (new_elements : List String) (h_precond : append_unique_elements_precond (elements) (new_elements)) : List String :=
  -- !benchmark @start code
  let rec go (acc : List String) (remaining : List String) : List String :=
    match remaining with
    | [] => acc
    | x :: xs => 
      if acc.contains x then
        go acc xs
      else
        go (acc ++ [x]) xs
  go elements new_elements
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def append_unique_elements_aux (elements : List String) (new_elements : List String) : List String :=
  let rec go (acc : List String) (remaining : List String) : List String :=
    match remaining with
    | [] => acc
    | x :: xs => 
      if acc.contains x then
        go acc xs
      else
        go (acc ++ [x]) xs
  go elements new_elements

-- Postcondition definitions
@[reducible, simp]
def append_unique_elements_postcond (elements : List String) (new_elements : List String) (result: List String) (h_precond : append_unique_elements_precond (elements) (new_elements)) : Prop :=
  -- !benchmark @start postcond
  result = append_unique_elements_aux elements new_elements
  -- !benchmark @end postcond


-- Proof content
theorem append_unique_elements_postcond_satisfied (elements: List String) (new_elements: List String) (h_precond : append_unique_elements_precond (elements) (new_elements)) :
    append_unique_elements_postcond (elements) (new_elements) (append_unique_elements (elements) (new_elements) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

