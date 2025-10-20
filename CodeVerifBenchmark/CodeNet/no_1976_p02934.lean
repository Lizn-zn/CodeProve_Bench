import Mathlib

namespace no_1976_p02934


-- Precondition definitions
@[reducible, simp]
def harmonicMean_precond (n : Nat) (a : List Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ n ≤ 100 ∧ a.length = n ∧ (∀ i : Fin n, 1 ≤ a[i]! ∧ a[i]! ≤ 1000)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def harmonicMean (n : Nat) (a : List Nat) (h_precond : harmonicMean_precond (n) (a)) : Float :=
  -- !benchmark @start code
  let sumInv := a.foldl (fun acc x => acc + (1.0 / x.toFloat)) 0.0
  1.0 / sumInv
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the sum of inverses
def sumOfInverses (a : List Nat) : Float :=
  a.foldl (fun acc x => acc + (1.0 / x.toFloat)) 0.0

-- Helper function to compute the harmonic mean value
def harmonicMeanValue (a : List Nat) : Float :=
  let sumInv := sumOfInverses a
  if sumInv == 0.0 then 0.0 else 1.0 / sumInv

-- Postcondition definitions
@[reducible, simp]
def harmonicMean_postcond (n : Nat) (a : List Nat) (result: Float) (h_precond : harmonicMean_precond (n) (a)) : Prop :=
  -- !benchmark @start postcond
  let expected := harmonicMeanValue a
  -- The result should be close to the expected harmonic mean
  -- We allow for floating point error
  (result - expected).abs ≤ 1e-5 * max result.abs expected.abs ∨ (result - expected).abs ≤ 1e-5
  -- !benchmark @end postcond


-- Proof content
theorem harmonicMean_postcond_satisfied (n: Nat) (a: List Nat) (h_precond : harmonicMean_precond (n) (a)) :
    harmonicMean_postcond (n) (a) (harmonicMean (n) (a) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1976_p02934