import Mathlib

namespace no_6071_syn_1_iter_6071


-- Precondition definitions
@[reducible, simp]
def sum_elements_greater_than_or_equal_precond (arr : Array Nat) (n : UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def sum_elements_greater_than_or_equal (arr : Array Nat) (n : UInt8) (h_precond : sum_elements_greater_than_or_equal_precond arr n) : Nat :=
  -- !benchmark @start code
  let rec loop (i : Nat) (acc : Nat) : Nat :=
      if h : i < arr.size then
        let elem := arr[i]'h
        if elem ≥ n.toNat then
          loop (i + 1) (acc + elem)
        else
          loop (i + 1) acc
      else
        acc
  loop 0 0
  -- !benchmark @end code


-- Postcondition definitions
def sum_elements_greater_than_or_equal_postcond (arr : Array Nat) (n : UInt8) (result: Nat) (h_precond : sum_elements_greater_than_or_equal_precond arr n) : Prop :=
  -- !benchmark @start postcond
  result = (arr.filter (λ x => x ≥ n.toNat)).foldl (λ acc x => acc + x) 0
  -- !benchmark @end postcond


-- Proof content
theorem sum_elements_greater_than_or_equal_postcond_satisfied (arr: Array Nat) (n: UInt8) (h_precond : sum_elements_greater_than_or_equal_precond arr n) :
    sum_elements_greater_than_or_equal_postcond arr n (sum_elements_greater_than_or_equal arr n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6071_syn_1_iter_6071