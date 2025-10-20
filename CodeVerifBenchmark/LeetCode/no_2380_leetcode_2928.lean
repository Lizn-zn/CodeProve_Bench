import Mathlib

namespace no_2380_leetcode_2928


-- Precondition auxiliary definitions
def is_valid_distribution (n : Nat) (limit : Nat) (a : Nat × Nat × Nat) : Prop :=
  let (x, y, z) := a
  x + y + z = n ∧ x ≤ limit ∧ y ≤ limit ∧ z ≤ limit

def count_valid_distributions (n : Nat) (limit : Nat) : Nat :=
  let candidates := List.range (n + 1)
  let triples := candidates.flatMap fun x =>
    candidates.flatMap fun y =>
      candidates.flatMap fun z =>
        if x + y + z = n ∧ x ≤ limit ∧ y ≤ limit ∧ z ≤ limit then
          [(x, y, z)]
        else
          []
  triples.length

-- Precondition definitions
@[reducible, simp]
def distributeCandies_precond (n : Nat) (limit : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ limit > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def countValidDistributions (n : Nat) (limit : Nat) : Nat :=
  let maxCandiesPerChild := min n limit
  let candidates := List.range (maxCandiesPerChild + 1)
  let validTriples := candidates.flatMap fun x =>
    let remainingAfterX := n - x
    let maxY := min remainingAfterX limit
    (List.range (maxY + 1)).flatMap fun y =>
      let z := remainingAfterX - y
      if z ≤ limit then
        [(x, y, z)]
      else
        []
  validTriples.length

-- Main function definitions
def distributeCandies (n : Nat) (limit : Nat) (h_precond : distributeCandies_precond (n) (limit)) : Nat :=
  -- !benchmark @start code
  countValidDistributions n limit
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def distributeCandies_postcond (n : Nat) (limit : Nat) (result: Nat) (h_precond : distributeCandies_precond (n) (limit)) : Prop :=
  -- !benchmark @start postcond
  result = count_valid_distributions n limit
  -- !benchmark @end postcond


-- Proof content
theorem distributeCandies_postcond_satisfied (n: Nat) (limit: Nat) (h_precond : distributeCandies_precond (n) (limit)) :
    distributeCandies_postcond (n) (limit) (distributeCandies (n) (limit) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2380_leetcode_2928