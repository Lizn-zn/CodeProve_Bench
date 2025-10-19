import Mathlib

-- Precondition definitions
@[reducible, simp]
def first_n_naturals_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def first_n_naturals (n : Nat) (h_precond : first_n_naturals_precond (n)) : Array Nat :=
  -- !benchmark @start code
  if n == 0 then
      #[]
    else
      let result : Array Nat := Array.mkEmpty n
      (List.range n).foldl (fun arr i => arr.push i) result
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def first_n_naturals_postcond (n : Nat) (result: Array Nat) (h_precond : first_n_naturals_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result.size = n ∧ ∀ (i : Fin result.size), result[i]! = i.val
  -- !benchmark @end postcond


-- Proof content
theorem first_n_naturals_postcond_satisfied (n: Nat) (h_precond : first_n_naturals_precond (n)) :
    first_n_naturals_postcond (n) (first_n_naturals (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof