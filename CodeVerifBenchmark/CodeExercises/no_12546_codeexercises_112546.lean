import Mathlib

-- Precondition auxiliary definitions
structure Animal where
  legs : Nat
  deriving Repr

-- Precondition definitions
@[reducible, simp]
def count_legs_precond (animals : List Animal) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def count_legs (animals : List Animal) (h_precond : count_legs_precond (animals)) : Nat :=
  -- !benchmark @start code
  match animals with
  | [] => 0
  | a::as => a.legs + count_legs as h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_legs_postcond (animals : List Animal) (result: Nat) (h_precond : count_legs_precond (animals)) : Prop :=
  -- !benchmark @start postcond
  result = (animals.map Animal.legs).sum
  -- !benchmark @end postcond


-- Proof content
theorem count_legs_postcond_satisfied (animals: List Animal) (h_precond : count_legs_precond (animals)) :
    count_legs_postcond (animals) (count_legs (animals) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

