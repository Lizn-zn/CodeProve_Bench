import Mathlib

namespace no_2168_p03149


-- Precondition definitions
@[reducible, simp]
def canArrangeTo1974_precond (n1 : Nat) (n2 : Nat) (n3 : Nat) (n4 : Nat) : Prop :=
  -- !benchmark @start precond
  -- Each input digit must be between 0 and 9 (inclusive)
  n1 ≤ 9 ∧ n2 ≤ 9 ∧ n3 ≤ 9 ∧ n4 ≤ 9
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def canArrangeTo1974 (n1 : Nat) (n2 : Nat) (n3 : Nat) (n4 : Nat) (h_precond : canArrangeTo1974_precond (n1) (n2) (n3) (n4)) : String :=
  -- !benchmark @start code
  let digits := [n1, n2, n3, n4]
    if digits.contains 1 && digits.contains 9 && digits.contains 7 && digits.contains 4 &&
       digits.count 1 = 1 && digits.count 9 = 1 && digits.count 7 = 1 && digits.count 4 = 1 then
      "YES"
    else
      "NO"
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Simpler definition: check if the multiset {n1, n2, n3, n4} equals {1, 9, 7, 4}
def canFormTarget (n1 n2 n3 n4 : Nat) : Bool :=
  let digits := [n1, n2, n3, n4]
  digits.contains 1 && digits.contains 9 && digits.contains 7 && digits.contains 4 &&
  digits.count 1 = 1 && digits.count 9 = 1 && digits.count 7 = 1 && digits.count 4 = 1

-- Postcondition definitions
@[reducible, simp]
def canArrangeTo1974_postcond (n1 : Nat) (n2 : Nat) (n3 : Nat) (n4 : Nat) (result: String) (h_precond : canArrangeTo1974_precond (n1) (n2) (n3) (n4)) : Prop :=
  -- !benchmark @start postcond
  -- The result is "YES" if and only if the four digits can be arranged to form "1974"
  -- This means the multiset {n1, n2, n3, n4} must equal the multiset {1, 9, 7, 4}
  (result = "YES" ↔ canFormTarget n1 n2 n3 n4 = true) ∧
  (result = "NO" ↔ canFormTarget n1 n2 n3 n4 = false) ∧
  (result = "YES" ∨ result = "NO")
  -- !benchmark @end postcond


-- Proof content
theorem canArrangeTo1974_postcond_satisfied (n1: Nat) (n2: Nat) (n3: Nat) (n4: Nat) (h_precond : canArrangeTo1974_precond (n1) (n2) (n3) (n4)) :
    canArrangeTo1974_postcond (n1) (n2) (n3) (n4) (canArrangeTo1974 (n1) (n2) (n3) (n4) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2168_p03149