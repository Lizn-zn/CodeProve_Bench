import Mathlib

-- Precondition definitions
@[reducible, simp]
def greater_than_basic_loop_precond (numbers : List Nat) (threshold : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def greater_than_basic_loop (numbers : List Nat) (threshold : Nat) (h_precond : greater_than_basic_loop_precond (numbers) (threshold)) : List Nat :=
  -- !benchmark @start code
  let result : List Nat := []
  numbers.foldl (λ acc num => if num > threshold then num :: acc else acc) result |>.reverse
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def greater_than_basic_loop_postcond (numbers : List Nat) (threshold : Nat) (result: List Nat) (h_precond : greater_than_basic_loop_precond (numbers) (threshold)) : Prop :=
  -- !benchmark @start postcond
  result = numbers.filter (λ x => x > threshold)
  -- !benchmark @end postcond


-- Proof content
theorem greater_than_basic_loop_postcond_satisfied (numbers: List Nat) (threshold: Nat) (h_precond : greater_than_basic_loop_precond (numbers) (threshold)) :
    greater_than_basic_loop_postcond (numbers) (threshold) (greater_than_basic_loop (numbers) (threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof