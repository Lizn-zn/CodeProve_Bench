import Mathlib

-- Precondition definitions
@[reducible, simp]
def tuple_list_intersection_precond (t : List α) (lst : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def tuple_list_intersection [DecidableEq α] (t : List α) (lst : List α) (h_precond : tuple_list_intersection_precond (t) (lst)) : Set α :=
  -- !benchmark @start code
  let common_elements := lst.filter (λ x => t.contains x)
  { x | x ∈ common_elements }
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def intersection_set (s1 s2 : List α) : Set α :=
  {x | x ∈ s1 ∧ x ∈ s2}

-- Postcondition definitions
@[reducible, simp]
def tuple_list_intersection_postcond (t : List α) (lst : List α) (result: Set α) (h_precond : tuple_list_intersection_precond (t) (lst)) : Prop :=
  -- !benchmark @start postcond
  result = intersection_set t lst
  -- !benchmark @end postcond


-- Proof content
theorem tuple_list_intersection_postcond_satisfied [DecidableEq α] (t: List α) (lst: List α) (h_precond : tuple_list_intersection_precond (t) (lst)) :
    tuple_list_intersection_postcond (t) (lst) (tuple_list_intersection (t) (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof