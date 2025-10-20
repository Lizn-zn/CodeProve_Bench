import Mathlib

namespace no_4899_syn_1_iter_4899


-- Precondition definitions
@[reducible, simp]
def sum_array_precond (arr : Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def sum_array (arr : Array Nat) (h_precond : sum_array_precond arr) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : Nat) : Nat :=
      if h : i < arr.size then
        loop (i + 1) (acc + arr[i]!)
      else
        acc
  loop 0 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sum_array_postcond (arr : Array Nat) (result: Nat) (h_precond : sum_array_precond arr) : Prop :=
  -- !benchmark @start postcond
  result = arr.foldl (λ acc x => acc + x) 0
  -- !benchmark @end postcond


-- Proof content
theorem sum_array_postcond_satisfied (arr: Array Nat) (h_precond : sum_array_precond arr) :
    sum_array_postcond arr (sum_array arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4899_syn_1_iter_4899