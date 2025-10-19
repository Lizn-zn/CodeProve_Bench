import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_positive_elements_precond (sequence : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def count_positive_elements (sequence : List Int) (h_precond : count_positive_elements_precond (sequence)) : Nat :=
  -- !benchmark @start code
  match sequence with
  | [] => 0
  | x :: xs => 
    if x > 0 then
      1 + count_positive_elements xs h_precond
    else
      count_positive_elements xs h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isPositive (x : Int) : Prop := x > 0

-- Postcondition definitions
@[reducible, simp]
def count_positive_elements_postcond (sequence : List Int) (result: Nat) (h_precond : count_positive_elements_precond (sequence)) : Prop :=
  -- !benchmark @start postcond
  result = (sequence.filter (λ x => x > 0)).length
  -- !benchmark @end postcond


-- Proof content
theorem count_positive_elements_postcond_satisfied (sequence: List Int) (h_precond : count_positive_elements_precond (sequence)) :
    count_positive_elements_postcond (sequence) (count_positive_elements (sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

