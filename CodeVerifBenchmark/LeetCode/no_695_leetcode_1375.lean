import Mathlib

-- Precondition auxiliary definitions
def IsPermutationOfRange (flips : List Nat) (n : Nat) : Prop :=
  flips.Perm (List.range (n + 1)).tail

-- Precondition definitions
@[reducible, simp]
def numTimesAllBlue_precond (flips : List Nat) : Prop :=
  -- !benchmark @start precond
  flips ≠ [] ∧ flips.length > 0 ∧
  (∀ i, i < flips.length → flips[i]! > 0 ∧ flips[i]! ≤ flips.length) ∧
  IsPermutationOfRange flips flips.length
  -- !benchmark @end precond


-- Main function definitions
def numTimesAllBlue (flips : List Nat) (h_precond : numTimesAllBlue_precond (flips)) : Nat :=
  -- !benchmark @start code
  let n := flips.length
    let rec loop (i : Nat) (maxSoFar : Nat) (count : Nat) : Nat :=
      if h : i < n then
        let currentFlip := flips[i]!
        let newMax := max maxSoFar currentFlip
        let newCount := if newMax = i + 1 then count + 1 else count
        loop (i + 1) newMax newCount
      else
        count
    loop 0 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def PrefixAlignedCount (flips : List Nat) : Nat :=
  let n := flips.length
  let rec helper (i : Nat) (maxSoFar : Nat) (count : Nat) : Nat :=
    if h : i < n then
      let flipIndex := flips[i]!
      let newMax := max maxSoFar flipIndex
      let newCount := if newMax = i + 1 then count + 1 else count
      helper (i + 1) newMax newCount
    else
      count
  helper 0 0 0

-- Postcondition definitions
@[reducible, simp]
def numTimesAllBlue_postcond (flips : List Nat) (result: Nat) (h_precond : numTimesAllBlue_precond (flips)) : Prop :=
  -- !benchmark @start postcond
  result = PrefixAlignedCount flips
  -- !benchmark @end postcond


-- Proof content
theorem numTimesAllBlue_postcond_satisfied (flips: List Nat) (h_precond : numTimesAllBlue_precond (flips)) :
    numTimesAllBlue_postcond (flips) (numTimesAllBlue (flips) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

