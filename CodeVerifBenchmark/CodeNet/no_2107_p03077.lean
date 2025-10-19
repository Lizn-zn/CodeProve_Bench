import Mathlib

-- Precondition definitions
@[reducible, simp]
def minTimeToReachCity6_precond (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) (e : Nat) : Prop :=
  -- !benchmark @start precond
  -- All capacities must be positive (at least 1 person can travel)
    a > 0 ∧ b > 0 ∧ c > 0 ∧ d > 0 ∧ e > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper lemmas for proving the postcondition
lemma min_pos {a b : Nat} (ha : a > 0) (hb : b > 0) : min a b > 0 := by
  cases Nat.le_total a b with
  | inl h => simp [Nat.min_eq_left h]; exact ha
  | inr h => simp [Nat.min_eq_right h]; exact hb

-- Main function definitions
def minTimeToReachCity6 (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) (e : Nat) (h_precond : minTimeToReachCity6_precond (n) (a) (b) (c) (d) (e)) : Nat :=
  -- !benchmark @start code
  let bottleneck := min a (min b (min c (min d e)))
    let trips := (n + bottleneck - 1) / bottleneck
    trips + 4
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the minimum time required
def computeMinTime (n : Nat) (a b c d e : Nat) : Nat :=
  let bottleneck := min a (min b (min c (min d e)))
  -- Number of trips needed through the bottleneck
  let trips := (n + bottleneck - 1) / bottleneck
  -- Total time is trips through bottleneck + 4 additional minutes for other legs
  trips + 4

-- Predicate to check if all people can reach City 6 in given time
def canReachInTime (n : Nat) (a b c d e : Nat) (time : Nat) : Prop :=
  -- Time must be at least 5 (minimum path length)
  time ≥ 5 ∧
  -- For each leg of the journey, check capacity constraints
  -- At time t, leg i can transport at most (t - i + 1) * capacity[i] people
  -- All n people must be able to traverse each leg
  (time - 0) * a ≥ n ∧  -- Train: City 1 → 2
  (time - 1) * b ≥ n ∧  -- Bus: City 2 → 3
  (time - 2) * c ≥ n ∧  -- Taxi: City 3 → 4
  (time - 3) * d ≥ n ∧  -- Airplane: City 4 → 5
  (time - 4) * e ≥ n    -- Ship: City 5 → 6

-- Postcondition definitions
@[reducible, simp]
def minTimeToReachCity6_postcond (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) (e : Nat) (result: Nat) (h_precond : minTimeToReachCity6_precond (n) (a) (b) (c) (d) (e)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the minimum time such that all people can reach City 6
    result = computeMinTime n a b c d e ∧
    -- The result satisfies the reachability constraint
    canReachInTime n a b c d e result ∧
    -- No smaller time works (minimality)
    (∀ t : Nat, t < result → ¬canReachInTime n a b c d e t)
  -- !benchmark @end postcond


-- Proof content
theorem minTimeToReachCity6_postcond_satisfied (n: Nat) (a: Nat) (b: Nat) (c: Nat) (d: Nat) (e: Nat) (h_precond : minTimeToReachCity6_precond (n) (a) (b) (c) (d) (e)) :
    minTimeToReachCity6_postcond (n) (a) (b) (c) (d) (e) (minTimeToReachCity6 (n) (a) (b) (c) (d) (e) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof