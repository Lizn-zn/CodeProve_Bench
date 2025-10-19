import Mathlib

-- Precondition definitions
@[reducible, simp]
def isProductEven_precond (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ a ∧ a ≤ 10000 ∧ 1 ≤ b ∧ b ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def isProductEven (a : Nat) (b : Nat) (h_precond : isProductEven_precond (a) (b)) : String :=
  -- !benchmark @start code
  if (a * b) % 2 = 0 then
    "Even"
  else
    "Odd"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def isProductEven_postcond (a : Nat) (b : Nat) (result: String) (h_precond : isProductEven_precond (a) (b)) : Prop :=
  -- !benchmark @start postcond
  (a * b) % 2 = 0 ∧ result = "Even" ∨ (a * b) % 2 = 1 ∧ result = "Odd"
  -- !benchmark @end postcond


-- Proof content
theorem isProductEven_postcond_satisfied (a: Nat) (b: Nat) (h_precond : isProductEven_precond (a) (b)) :
    isProductEven_postcond (a) (b) (isProductEven (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

