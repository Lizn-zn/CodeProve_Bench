import Mathlib

-- Precondition definitions
@[reducible, simp]
def square_array_precond (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def square_array (arr : Array Nat) (h_precond : square_array_precond (arr)) : Array Nat :=
  -- !benchmark @start code
  if arr.isEmpty then
    #[]
  else
    let result : Array Nat := Array.mkEmpty arr.size
    let result := Array.foldl (λ acc i => acc.push (arr[i]! ^ 2)) result (Array.range arr.size)
    result
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def square_array_postcond (arr : Array Nat) (result: Array Nat) (h_precond : square_array_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result.size = arr.size ∧ ∀ (i : Nat) (h : i < result.size), result[i]! = (arr[i]!) ^ 2
  -- !benchmark @end postcond


-- Proof content
theorem square_array_postcond_satisfied (arr: Array Nat) (h_precond : square_array_precond (arr)) :
    square_array_postcond (arr) (square_array (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof