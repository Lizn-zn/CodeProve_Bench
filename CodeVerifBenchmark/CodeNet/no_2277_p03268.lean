import Mathlib

-- Precondition definitions
@[reducible, simp]
def countValidTriples_precond (N : Nat) (K : Nat) : Prop :=
  -- !benchmark @start precond
  K > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countValidTriples (N : Nat) (K : Nat) (h_precond : countValidTriples_precond (N) (K)) : Nat :=
  -- !benchmark @start code
  Id.run do
    let mut ans := 0
    for i in [1:N+1] do
      let a := ((i / K + 1) * K - i)
      if a ≤ N ∧ (a * 2) % K = 0 then
        let p := (N - a) / K + 1
        ans := ans + p * p
    return ans
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper predicate to check if a triple (a, b, c) satisfies the conditions
def isValidTriple (N K a b c : Nat) : Prop :=
  1 ≤ a ∧ a ≤ N ∧
  1 ≤ b ∧ b ≤ N ∧
  1 ≤ c ∧ c ≤ N ∧
  (a + b) % K = 0 ∧
  (b + c) % K = 0 ∧
  (c + a) % K = 0

-- Make isValidTriple decidable
instance (N K a b c : Nat) : Decidable (isValidTriple N K a b c) :=
  inferInstanceAs (Decidable (1 ≤ a ∧ a ≤ N ∧ 1 ≤ b ∧ b ≤ N ∧ 1 ≤ c ∧ c ≤ N ∧ (a + b) % K = 0 ∧ (b + c) % K = 0 ∧ (c + a) % K = 0))

-- Count the number of valid triples
def countTriples (N K : Nat) : Nat :=
  (List.range N).foldl (fun acc1 a =>
    acc1 + (List.range N).foldl (fun acc2 b =>
      acc2 + (List.range N).foldl (fun acc3 c =>
        if isValidTriple N K (a + 1) (b + 1) (c + 1) then acc3 + 1 else acc3
      ) 0
    ) 0
  ) 0

-- Postcondition definitions
@[reducible, simp]
def countValidTriples_postcond (N : Nat) (K : Nat) (result: Nat) (h_precond : countValidTriples_precond (N) (K)) : Prop :=
  -- !benchmark @start postcond
  result = countTriples N K
  -- !benchmark @end postcond


-- Proof content
theorem countValidTriples_postcond_satisfied (N: Nat) (K: Nat) (h_precond : countValidTriples_precond (N) (K)) :
    countValidTriples_postcond (N) (K) (countValidTriples (N) (K) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof