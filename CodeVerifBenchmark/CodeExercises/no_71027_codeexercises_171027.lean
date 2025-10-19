import Mathlib

-- Precondition definitions
@[reducible, simp]
def check_numbers_precond (numbers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def check_numbers (numbers : List Nat) (h_precond : check_numbers_precond (numbers)) : Bool :=
  -- !benchmark @start code
  let rec loop (nums : List Nat) : Bool :=
      match nums with
      | [] => true
      | x :: xs => if x > 10 then loop xs else false
    loop numbers
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def check_numbers_postcond (numbers : List Nat) (result: Bool) (h_precond : check_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = (∀ x ∈ numbers, x > 10)
  -- !benchmark @end postcond


-- Proof content
theorem check_numbers_postcond_satisfied (numbers: List Nat) (h_precond : check_numbers_precond (numbers)) :
    check_numbers_postcond (numbers) (check_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

