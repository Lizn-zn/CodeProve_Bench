import Mathlib

namespace no_426_p00479


-- Precondition definitions
@[reducible, simp]
def getTileColor_precond (n : Nat) (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ 1 ≤ a ∧ a ≤ n ∧ 1 ≤ b ∧ b ≤ n
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def getTileColor (n : Nat) (a : Nat) (b : Nat) (h_precond : getTileColor_precond (n) (a) (b)) : Nat :=
  -- !benchmark @start code
  let distFromLeft := a
    let distFromRight := n - a + 1
    let distFromTop := b
    let distFromBottom := n - b + 1
    let ring := min (min distFromLeft distFromRight) (min distFromTop distFromBottom)
    let c := ring % 3
    if c = 0 then 3 else c
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to determine which ring/layer a position belongs to
-- The ring is determined by the minimum distance from any edge
def ringNumber (n : Nat) (a : Nat) (b : Nat) : Nat :=
  let distFromLeft := a
  let distFromRight := n - a + 1
  let distFromTop := b
  let distFromBottom := n - b + 1
  min (min distFromLeft distFromRight) (min distFromTop distFromBottom)

-- Helper function to map ring number to color
-- Ring 1 (outermost) is red (1), ring 2 is blue (2), ring 3 is yellow (3), then repeats
def ringToColor (ring : Nat) : Nat :=
  let c := ring % 3
  if c = 0 then 3 else c

-- Postcondition definitions
@[reducible, simp]
def getTileColor_postcond (n : Nat) (a : Nat) (b : Nat) (result: Nat) (h_precond : getTileColor_precond (n) (a) (b)) : Prop :=
  -- !benchmark @start postcond
  result ∈ ({1, 2, 3} : Set Nat) ∧ 
    result = ringToColor (ringNumber n a b)
  -- !benchmark @end postcond


-- Proof content
theorem getTileColor_postcond_satisfied (n: Nat) (a: Nat) (b: Nat) (h_precond : getTileColor_precond (n) (a) (b)) :
    getTileColor_postcond (n) (a) (b) (getTileColor (n) (a) (b) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_426_p00479