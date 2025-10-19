import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def minCoinsToReachN_precond (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) : Prop :=
  -- !benchmark @start precond
  n ≥ 1 ∧ a ≥ 1 ∧ b ≥ 1 ∧ c ≥ 1 ∧ d ≥ 1
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Priority queue implementation using a sorted list
structure PQEntry where
  cost : Nat
  value : Nat
deriving Repr, DecidableEq

def PQEntry.le (a b : PQEntry) : Bool :=
  a.cost ≤ b.cost

-- Insert into priority queue maintaining sorted order
def pqInsert (pq : List PQEntry) (entry : PQEntry) : List PQEntry :=
  match pq with
  | [] => [entry]
  | h :: t => if entry.cost ≤ h.cost then entry :: h :: t else h :: pqInsert t entry

-- Pop minimum from priority queue
def pqPop (pq : List PQEntry) : Option (PQEntry × List PQEntry) :=
  match pq with
  | [] => none
  | h :: t => some (h, t)

-- Dijkstra-style search to find minimum cost
partial def dijkstraSearch (n a b c d : Nat) (pq : List PQEntry) (used : List Nat) (fuel : Nat) : Nat :=
  if fuel = 0 then d -- fallback
  else
    match pqPop pq with
    | none => d -- shouldn't happen
    | some (entry, rest) =>
      if entry.value ∈ used then
        dijkstraSearch n a b c d rest used (fuel - 1)
      else if entry.value = 1 then
        entry.cost + d
      else
        let newUsed := entry.value :: used
        let newPq0 := rest
        
        -- Try dividing by 5
        let d5 := entry.value / 5
        let m5 := entry.value % 5
        let newPq1 := if d5 > 0 then pqInsert newPq0 ⟨entry.cost + m5 * d + c, d5⟩ else newPq0
        let newPq2 := if m5 > 0 then pqInsert newPq1 ⟨entry.cost + (5 - m5) * d + c, d5 + 1⟩ else newPq1
        
        -- Try dividing by 3
        let d3 := entry.value / 3
        let m3 := entry.value % 3
        let newPq3 := if d3 > 0 then pqInsert newPq2 ⟨entry.cost + m3 * d + b, d3⟩ else newPq2
        let newPq4 := if m3 > 0 then pqInsert newPq3 ⟨entry.cost + (3 - m3) * d + b, d3 + 1⟩ else newPq3
        
        -- Try dividing by 2
        let d2 := entry.value / 2
        let m2 := entry.value % 2
        let newPq5 := if d2 > 0 then pqInsert newPq4 ⟨entry.cost + m2 * d + a, d2⟩ else newPq4
        let newPq6 := if m2 > 0 then pqInsert newPq5 ⟨entry.cost + (2 - m2) * d + a, d2 + 1⟩ else newPq5
        
        -- Direct path to 1
        let newPq := pqInsert newPq6 ⟨entry.cost + (entry.value - 1) * d, 1⟩
        
        dijkstraSearch n a b c d newPq newUsed (fuel - 1)

-- Main function definitions
def minCoinsToReachN (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) (h_precond : minCoinsToReachN_precond (n) (a) (b) (c) (d)) : Nat :=
  -- !benchmark @start code
  -- Use a large fuel value to ensure termination
    let fuel := 10000
    let initialPq := [⟨0, n⟩]
    dijkstraSearch n a b c d initialPq [] fuel
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Represents a valid sequence of operations to reach n from 0
inductive ReachN : Nat → Nat → Nat → Nat → Nat → Nat → Nat → Prop where
  | base : ∀ d, ReachN 0 a b c d 1 d  -- Start at 0, increment to 1, cost d
  | mul2 : ∀ {x cost}, ReachN n a b c d x cost → ReachN n a b c d (2 * x) (cost + a)
  | mul3 : ∀ {x cost}, ReachN n a b c d x cost → ReachN n a b c d (3 * x) (cost + b)
  | mul5 : ∀ {x cost}, ReachN n a b c d x cost → ReachN n a b c d (5 * x) (cost + c)
  | inc : ∀ {x cost}, x ≥ 1 → ReachN n a b c d x cost → ReachN n a b c d (x + 1) (cost + d)
  | dec : ∀ {x cost}, x ≥ 2 → ReachN n a b c d x cost → ReachN n a b c d (x - 1) (cost + d)

-- The result is the minimum cost among all valid sequences
def isMinCost (n a b c d cost : Nat) : Prop :=
  ReachN n a b c d n cost ∧ ∀ cost', ReachN n a b c d n cost' → cost ≤ cost'

-- Postcondition definitions
@[reducible, simp]
def minCoinsToReachN_postcond (n : Nat) (a : Nat) (b : Nat) (c : Nat) (d : Nat) (result: Nat) (h_precond : minCoinsToReachN_precond (n) (a) (b) (c) (d)) : Prop :=
  -- !benchmark @start postcond
  isMinCost n a b c d result
  -- !benchmark @end postcond


-- Proof content
theorem minCoinsToReachN_postcond_satisfied (n: Nat) (a: Nat) (b: Nat) (c: Nat) (d: Nat) (h_precond : minCoinsToReachN_precond (n) (a) (b) (c) (d)) :
    minCoinsToReachN_postcond (n) (a) (b) (c) (d) (minCoinsToReachN (n) (a) (b) (c) (d) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof