import Mathlib

-- Precondition definitions
@[reducible, simp]
def lawyer_exercise_precond (lst1 : List String) (lst2 : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def lawyer_exercise (lst1 : List String) (lst2 : List String) (h_precond : lawyer_exercise_precond (lst1) (lst2)) : List String :=
  -- !benchmark @start code
  let intersection_list := List.filter (λ x => List.elem x lst2) lst1
  intersection_list
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_intersection (lst1 lst2 result : List String) : Prop :=
  ∀ x, x ∈ result ↔ (x ∈ lst1 ∧ x ∈ lst2) ∧ (∀ i, i < result.length → result.get? i = some x → result.count x = 1)

-- Postcondition definitions
@[reducible, simp]
def lawyer_exercise_postcond (lst1 : List String) (lst2 : List String) (result: List String) (h_precond : lawyer_exercise_precond (lst1) (lst2)) : Prop :=
  -- !benchmark @start postcond
  is_intersection lst1 lst2 result
  -- !benchmark @end postcond


-- Proof content
theorem lawyer_exercise_postcond_satisfied (lst1: List String) (lst2: List String) (h_precond : lawyer_exercise_precond (lst1) (lst2)) :
    lawyer_exercise_postcond (lst1) (lst2) (lawyer_exercise (lst1) (lst2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof