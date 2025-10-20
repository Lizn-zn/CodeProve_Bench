import Mathlib

namespace no_66547_codeexercises_166547


-- Precondition definitions
@[reducible, simp]
def find_greatest_precond (a : Nat) (b : Nat) (c : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def find_greatest (a : Nat) (b : Nat) (c : Nat) (h_precond : find_greatest_precond (a) (b) (c)) : Nat :=
  -- !benchmark @start code
  if a ≥ b then
      if a ≥ c then
        a
      else
        c
    else
      if b ≥ c then
        b
      else
        c
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_greatest_postcond (a : Nat) (b : Nat) (c : Nat) (result: Nat) (h_precond : find_greatest_precond (a) (b) (c)) : Prop :=
  -- !benchmark @start postcond
  result = max a (max b c) ∧ result ≥ a ∧ result ≥ b ∧ result ≥ c
  -- !benchmark @end postcond


-- Proof content
theorem find_greatest_postcond_satisfied (a: Nat) (b: Nat) (c: Nat) (h_precond : find_greatest_precond (a) (b) (c)) :
    find_greatest_postcond (a) (b) (c) (find_greatest (a) (b) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_66547_codeexercises_166547