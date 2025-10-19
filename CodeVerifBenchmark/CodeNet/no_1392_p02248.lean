import Mathlib

-- Precondition definitions
@[reducible, simp]
def kmpMatcher_precond (t : String) (p : String) : Prop :=
  -- !benchmark @start precond
  -- Precondition: both strings are non-empty and within the specified length constraints
  1 ≤ t.length ∧ t.length ≤ 1000000 ∧
  1 ≤ p.length ∧ p.length ≤ 10000
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Compute the prefix function for KMP algorithm
def computePrefixFunction (p : String) : Array Nat :=
  let m := p.length
  let chars := p.toList.toArray
  Id.run do
    let mut pi := Array.mkArray (m + 1) 0
    let mut k := 0
    for q in [2:m + 1] do
      while k > 0 && chars[k]! != chars[q - 1]! do
        k := pi[k]!
      if chars[k]! == chars[q - 1]! then
        k := k + 1
      pi := pi.set! q k
    return pi

-- Main function definitions
def kmpMatcher (t : String) (p : String) (h_precond : kmpMatcher_precond (t) (p)) : List Nat :=
  -- !benchmark @start code
  let n := t.length
  let m := p.length
  let pi := computePrefixFunction p
  let tChars := t.toList.toArray
  let pChars := p.toList.toArray
  Id.run do
    let mut result := []
    let mut q := 0
    for i in [1:n + 1] do
      while q > 0 && pChars[q]! != tChars[i - 1]! do
        q := pi[q]!
      if pChars[q]! == tChars[i - 1]! then
        q := q + 1
      if q == m then
        result := result ++ [i - m]
        q := pi[q]!
    return result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if pattern p matches text t at position i
def matchesAt (t : String) (p : String) (i : Nat) : Bool :=
  if i + p.length > t.length then false
  else
    let tSubstr := t.extract ⟨i⟩ ⟨i + p.length⟩
    tSubstr = p

-- Get all valid match positions
def allMatches (t : String) (p : String) : List Nat :=
  (List.range t.length).filter (fun i => matchesAt t p i)

-- Postcondition definitions
@[reducible, simp]
def kmpMatcher_postcond (t : String) (p : String) (result: List Nat) (h_precond : kmpMatcher_precond (t) (p)) : Prop :=
  -- !benchmark @start postcond
  -- Postcondition: result contains exactly all indices where p is found in t, in ascending order
  -- 1. All indices in result are valid match positions
  (∀ i ∈ result, i < t.length ∧ matchesAt t p i) ∧
  -- 2. All valid match positions are in result
  (∀ i, i < t.length → matchesAt t p i → i ∈ result) ∧
  -- 3. Result is sorted in ascending order
  (result.Pairwise (· < ·)) ∧
  -- 4. No duplicates in result
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem kmpMatcher_postcond_satisfied (t: String) (p: String) (h_precond : kmpMatcher_precond (t) (p)) :
    kmpMatcher_postcond (t) (p) (kmpMatcher (t) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof