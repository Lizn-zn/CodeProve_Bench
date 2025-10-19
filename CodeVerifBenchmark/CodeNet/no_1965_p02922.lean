import Mathlib

-- Precondition definitions
@[reducible, simp]
def minPowerStrips_precond (A : Nat) (B : Nat) : Prop :=
  -- !benchmark @start precond
  2 ≤ A ∧ A ≤ 20 ∧ 1 ≤ B ∧ B ≤ 20
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the minimum number of strips needed
def computeMinStrips (A : Nat) (B : Nat) : Nat :=
  if B ≤ 1 then
    0  -- Already have 1 socket, no strips needed
  else
    -- Need to solve: 1 + n * (A - 1) ≥ B
    -- Which gives: n ≥ (B - 1) / (A - 1)
    -- We need ceiling division: (B - 1 + A - 2) / (A - 1)
    (B - 1 + A - 2) / (A - 1)

-- Main function definitions
def minPowerStrips (A : Nat) (B : Nat) (h_precond : minPowerStrips_precond (A) (B)) : Nat :=
  -- !benchmark @start code
  if B ≤ 1 then
      0
    else
      -- Calculate minimum n such that 1 + n * (A - 1) ≥ B
      -- Rearranging: n * (A - 1) ≥ B - 1
      -- So: n ≥ (B - 1) / (A - 1), rounded up
      let needed := B - 1
      let perStrip := A - 1
      (needed + perStrip - 1) / perStrip
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Calculate the number of empty sockets after using n power strips
def socketsAfterStrips (A : Nat) (n : Nat) : Nat :=
  if n = 0 then 1  -- Start with 1 socket
  else 1 + n * (A - 1)  -- 1 initial + n strips each adding (A-1) sockets

-- Postcondition definitions
@[reducible, simp]
def minPowerStrips_postcond (A : Nat) (B : Nat) (result: Nat) (h_precond : minPowerStrips_precond (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum number of power strips needed
  -- such that we have at least B empty sockets
  socketsAfterStrips A result ≥ B ∧ 
  (result = 0 ∨ socketsAfterStrips A (result - 1) < B)
  -- !benchmark @end postcond


-- Proof content
theorem minPowerStrips_postcond_satisfied (A: Nat) (B: Nat) (h_precond : minPowerStrips_precond (A) (B)) :
    minPowerStrips_postcond (A) (B) (minPowerStrips (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

