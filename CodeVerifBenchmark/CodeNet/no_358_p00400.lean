import Mathlib

-- Precondition definitions
@[reducible, simp]
def classifyAsciiCode_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  -- The input n must be a valid ASCII code value (0 ≤ n ≤ 127)
  n ≤ 127
  -- !benchmark @end precond


-- Main function definitions
def classifyAsciiCode (n : Nat) (h_precond : classifyAsciiCode_precond (n)) : Nat :=
  -- !benchmark @start code
  if 65 ≤ n ∧ n ≤ 90 then
    1
  else if 97 ≤ n ∧ n ≤ 122 then
    2
  else
    0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def classifyAsciiCode_postcond (n : Nat) (result: Nat) (h_precond : classifyAsciiCode_precond (n)) : Prop :=
  -- !benchmark @start postcond
  -- The result classifies the ASCII code:
    -- 1 if n represents an uppercase letter (65 ≤ n ≤ 90)
    -- 2 if n represents a lowercase letter (97 ≤ n ≤ 122)
    -- 0 otherwise
    (65 ≤ n ∧ n ≤ 90 → result = 1) ∧
    (97 ≤ n ∧ n ≤ 122 → result = 2) ∧
    ((n < 65 ∨ (90 < n ∧ n < 97) ∨ 122 < n) → result = 0)
  -- !benchmark @end postcond


-- Proof content
theorem classifyAsciiCode_postcond_satisfied (n: Nat) (h_precond : classifyAsciiCode_precond (n)) :
    classifyAsciiCode_postcond (n) (classifyAsciiCode (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

