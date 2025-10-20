import Mathlib

namespace no_1942_p02897


-- Precondition definitions
@[reducible, simp]
def oddProbability_precond (N : Nat) : Prop :=
  -- !benchmark @start precond
  N ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count odd numbers from 1 to N
def countOddsImpl (N : Nat) : Nat :=
  let rec loop (i : Nat) (count : Nat) : Nat :=
    if i > N then
      count
    else
      let newCount := if i % 2 == 1 then count + 1 else count
      loop (i + 1) newCount
  termination_by N - i + 1
  decreasing_by sorry
  loop 1 0

-- Main function definitions
def oddProbability (N : Nat) (h_precond : oddProbability_precond (N)) : Float :=
  -- !benchmark @start code
  -- Count odd numbers from 1 to N
    let count := countOddsImpl N
    -- Calculate probability as Float
    (count.toFloat / N.toFloat)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count of odd numbers from 1 to N
def countOdds (N : Nat) : Nat :=
  (N + 1) / 2

-- The probability as a rational number
def oddProbabilityRational (N : Nat) : Rat :=
  (countOdds N : Rat) / (N : Rat)

-- Postcondition definitions
@[reducible, simp]
def oddProbability_postcond (N : Nat) (result: Float) (h_precond : oddProbability_precond (N)) : Prop :=
  -- !benchmark @start postcond
  -- The result should be the probability of choosing an odd number
  -- which is the count of odd numbers divided by N
  let expected := oddProbabilityRational N
  -- The float result should be approximately equal to the rational probability
  let expectedFloat := (expected.num.natAbs.toFloat / expected.den.toFloat) * (if expected.num ≥ 0 then 1.0 else -1.0)
  Float.abs (result - expectedFloat) ≤ 1e-6
  -- !benchmark @end postcond


-- Proof content
theorem oddProbability_postcond_satisfied (N: Nat) (h_precond : oddProbability_precond (N)) :
    oddProbability_postcond (N) (oddProbability (N) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1942_p02897