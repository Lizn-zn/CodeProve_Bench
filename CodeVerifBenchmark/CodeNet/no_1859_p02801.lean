import Mathlib

namespace no_1859_p02801


-- Precondition definitions
@[reducible, simp]
def nextLetter_precond (c : Char) : Prop :=
  -- !benchmark @start precond
  c.isLower ∧ c ≠ 'z'
  -- !benchmark @end precond


-- Main function definitions
def nextLetter (c : Char) (h_precond : nextLetter_precond (c)) : Char :=
  -- !benchmark @start code
  Char.ofNat (c.toNat + 1)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def nextLetter_postcond (c : Char) (result: Char) (h_precond : nextLetter_precond (c)) : Prop :=
  -- !benchmark @start postcond
  result.toNat = c.toNat + 1 ∧ result.isLower
  -- !benchmark @end postcond


-- Proof content
theorem nextLetter_postcond_satisfied (c: Char) (h_precond : nextLetter_precond (c)) :
    nextLetter_postcond (c) (nextLetter (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1859_p02801