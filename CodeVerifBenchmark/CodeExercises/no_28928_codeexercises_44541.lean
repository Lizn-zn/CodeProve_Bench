import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_odd_numbers_precond (sequence : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_odd (n : Int) : Bool := n % 2 ≠ 0

-- Main function definitions
def count_odd_numbers (sequence : List Int) (h_precond : count_odd_numbers_precond (sequence)) : Nat :=
  -- !benchmark @start code
  match sequence with
  | [] => 0
  | x :: xs => 
    let rest_count := count_odd_numbers xs (by simp [count_odd_numbers_precond])
    if is_odd x then rest_count + 1 else rest_count
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_odd_numbers_postcond (sequence : List Int) (result: Nat) (h_precond : count_odd_numbers_precond (sequence)) : Prop :=
  -- !benchmark @start postcond
  result = (sequence.filter is_odd).length
  -- !benchmark @end postcond


-- Proof content
theorem count_odd_numbers_postcond_satisfied (sequence: List Int) (h_precond : count_odd_numbers_precond (sequence)) :
    count_odd_numbers_postcond (sequence) (count_odd_numbers (sequence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof