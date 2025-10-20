import Mathlib

namespace no_4987_syn_1_iter_4987


-- Precondition definitions
@[reducible, simp]
def count_positive_in_set_precond (xs : List Int) (s : Finset Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def count_positive_in_set (xs : List Int) (s : Finset Nat) (h_precond : count_positive_in_set_precond (xs) (s)) : UInt8 :=
  -- !benchmark @start code
  xs.foldl (λ count x => 
    if x > 0 then
      let n : Nat := Int.toNat x
      if n ∈ s then
        count + 1
      else
        count
    else
      count) 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_positive_in_set_postcond (xs : List Int) (s : Finset Nat) (result: UInt8) (h_precond : count_positive_in_set_precond (xs) (s)) : Prop :=
  -- !benchmark @start postcond
  result = (List.filter (λ x => x > 0 ∧ (x.toNat : Nat) ∈ s) xs).length.toUInt8
  -- !benchmark @end postcond


-- Proof content
theorem count_positive_in_set_postcond_satisfied (xs: List Int) (s: Finset Nat) (h_precond : count_positive_in_set_precond (xs) (s)) :
    count_positive_in_set_postcond (xs) (s) (count_positive_in_set (xs) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4987_syn_1_iter_4987