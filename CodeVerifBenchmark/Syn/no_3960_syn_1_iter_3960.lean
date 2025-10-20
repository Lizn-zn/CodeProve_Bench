import Mathlib

namespace no_3960_syn_1_iter_3960

-- Precondition definitions
@[reducible, simp]
def construct_array_precond (a : Int) (b : Nat) (S : Finset Nat) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def construct_array (a : Int) (b : Nat) (S : Finset Nat) (n : Nat) (h_precond : construct_array_precond (a) (b) (S) (n)) : Array Int :=
  -- !benchmark @start code
  Id.run do
    let mut arr : Array Int := Array.mkEmpty n
    for i in [0:n] do
      if i ∈ S then
        arr := arr.push (a + b * (i : Int))
      else
        arr := arr.push 0
    return arr
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def construct_array_postcond (a : Int) (b : Nat) (S : Finset Nat) (n : Nat) (result: Array Int) (h_precond : construct_array_precond (a) (b) (S) (n)) : Prop :=
  -- !benchmark @start postcond
  result.size = n ∧ ∀ (i : Fin n), result[i]! = if i.1 ∈ S then a + b * (i.1 : Int) else 0
  -- !benchmark @end postcond


-- Proof content
theorem construct_array_postcond_satisfied (a: Int) (b: Nat) (S: Finset Nat) (n: Nat) (h_precond : construct_array_precond (a) (b) (S) (n)) :
    construct_array_postcond (a) (b) (S) (n) (construct_array (a) (b) (S) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3960_syn_1_iter_3960
