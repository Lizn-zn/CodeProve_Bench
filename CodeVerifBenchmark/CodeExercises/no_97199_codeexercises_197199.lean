import Mathlib

-- Precondition definitions
@[reducible, simp]
def list_modification_precond (nested_set_list : List (List (Set ℤ))) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def list_modification (nested_set_list : List (List (Set ℤ))) (h_precond : list_modification_precond (nested_set_list)) : List (List (Set ℤ)) :=
  -- !benchmark @start code
  match nested_set_list with
  | [] => []
  | outer_list => outer_list.map (λ inner_list => inner_list.map (λ s => {x | ∃ y ∈ s, x = y + 10}))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def add_ten_to_set (s : Set ℤ) : Set ℤ :=
  {x | ∃ y ∈ s, x = y + 10}

def modify_inner_sets : List (List (Set ℤ)) → List (List (Set ℤ))
  | [] => []
  | outer_list => outer_list.map (λ inner_list => inner_list.map add_ten_to_set)

-- Postcondition definitions
@[reducible, simp]
def list_modification_postcond (nested_set_list : List (List (Set ℤ))) (result: List (List (Set ℤ))) (h_precond : list_modification_precond (nested_set_list)) : Prop :=
  -- !benchmark @start postcond
  result = modify_inner_sets nested_set_list
  -- !benchmark @end postcond


-- Proof content
theorem list_modification_postcond_satisfied (nested_set_list: List (List (Set ℤ))) (h_precond : list_modification_precond (nested_set_list)) :
    list_modification_postcond (nested_set_list) (list_modification (nested_set_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

