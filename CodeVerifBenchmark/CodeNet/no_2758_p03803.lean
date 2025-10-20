import Mathlib

namespace no_2758_p03803


-- Precondition definitions
@[reducible, simp]
def oneCardPoker_precond (A : Nat) (B : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ A ∧ A ≤ 13 ∧ 1 ≤ B ∧ B ≤ 13
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
-- Helper function to convert card value to strength
-- Card 1 has the highest strength (14), cards 2-13 have their face value as strength
def cardStrength (n : Nat) : Nat :=
  if n = 1 then 14 else n


-- Main function definitions
def oneCardPoker (A : Nat) (B : Nat) (h_precond : oneCardPoker_precond (A) (B)) : String :=
  -- !benchmark @start code
  let strengthA := cardStrength A
    let strengthB := cardStrength B
    if strengthA > strengthB then
      "Alice"
    else if strengthA < strengthB then
      "Bob"
    else
      "Draw"
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def oneCardPoker_postcond (A : Nat) (B : Nat) (result: String) (h_precond : oneCardPoker_precond (A) (B)) : Prop :=
  -- !benchmark @start postcond
  let strengthA := cardStrength A
    let strengthB := cardStrength B
    (strengthA > strengthB → result = "Alice") ∧
    (strengthA < strengthB → result = "Bob") ∧
    (strengthA = strengthB → result = "Draw")
  -- !benchmark @end postcond


-- Proof content
theorem oneCardPoker_postcond_satisfied (A: Nat) (B: Nat) (h_precond : oneCardPoker_precond (A) (B)) :
    oneCardPoker_postcond (A) (B) (oneCardPoker (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2758_p03803