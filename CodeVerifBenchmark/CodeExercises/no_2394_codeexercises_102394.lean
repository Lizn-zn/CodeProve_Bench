import Mathlib

namespace no_2394_codeexercises_102394


-- Precondition definitions
@[reducible, simp]
def find_smallest_precond (num1 : Nat) (num2 : Nat) (num3 : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def find_smallest (num1 : Nat) (num2 : Nat) (num3 : Nat) (h_precond : find_smallest_precond (num1) (num2) (num3)) : Nat :=
  -- !benchmark @start code
  if num1 ≤ num2 then
      if num1 ≤ num3 then
        num1
      else
        num3
    else
      if num2 ≤ num3 then
        num2
      else
        num3
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_smallest_postcond (num1 : Nat) (num2 : Nat) (num3 : Nat) (result: Nat) (h_precond : find_smallest_precond (num1) (num2) (num3)) : Prop :=
  -- !benchmark @start postcond
  result = min num1 (min num2 num3)
  -- !benchmark @end postcond


-- Proof content
theorem find_smallest_postcond_satisfied (num1: Nat) (num2: Nat) (num3: Nat) (h_precond : find_smallest_precond (num1) (num2) (num3)) :
    find_smallest_postcond (num1) (num2) (num3) (find_smallest (num1) (num2) (num3) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2394_codeexercises_102394