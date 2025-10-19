import Mathlib

-- Precondition definitions
@[reducible, simp]
def create_constant_array_precond (x : Int) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def create_constant_array (x : Int) (n : Nat) (h_precond : create_constant_array_precond (x) (n)) : Array Int :=
  -- !benchmark @start code
  Id.run do
    let mut arr := Array.mkEmpty n
    for i in [:n] do
      arr := arr.push x
    return arr
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def create_constant_array_postcond (x : Int) (n : Nat) (result: Array Int) (h_precond : create_constant_array_precond (x) (n)) : Prop :=
  -- !benchmark @start postcond
  result.size = n ∧ ∀ (i : Fin result.size), result[i]! = x
  -- !benchmark @end postcond


-- Proof content
theorem create_constant_array_postcond_satisfied (x: Int) (n: Nat) (h_precond : create_constant_array_precond (x) (n)) :
    create_constant_array_postcond (x) (n) (create_constant_array (x) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof