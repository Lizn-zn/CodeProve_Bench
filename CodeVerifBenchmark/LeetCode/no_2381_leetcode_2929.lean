import Mathlib

-- Precondition auxiliary definitions
def countCandyDistributions_precond_aux (n : Nat) (limit : Nat) : Prop :=
  1 ≤ n ∧ 1 ≤ limit

-- Precondition definitions
@[reducible, simp]
def countCandyDistributions_precond (n : Nat) (limit : Nat) : Prop :=
  -- !benchmark @start precond
  countCandyDistributions_precond_aux n limit
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Efficiently compute the number of valid distributions using mathematical derivation. -/
def countCandyDistributions_efficient (n : Nat) (limit : Nat) : Nat :=
  let total := (n + 2) * (n + 1) / 2
  let subtract1 := if n > limit then (n - limit + 1) * (n - limit) / 2 else 0
  let subtract2 := if n > limit then (n - limit + 1) * (n - limit) / 2 else 0
  let subtract3 := if n > limit then (n - limit + 1) * (n - limit) / 2 else 0
  let add12 := if n > 2 * limit then (n - 2 * limit) * (n - 2 * limit - 1) / 2 else 0
  let add13 := if n > 2 * limit then (n - 2 * limit) * (n - 2 * limit - 1) / 2 else 0
  let add23 := if n > 2 * limit then (n - 2 * limit) * (n - 2 * limit - 1) / 2 else 0
  let subtract123 := if n > 3 * limit then (n - 3 * limit + 2) * (n - 3 * limit + 1) / 2 else 0
  (total - subtract1 - subtract2 - subtract3 + add12 + add13 + add23 - subtract123)


-- Main function definitions
def countCandyDistributions (n : Nat) (limit : Nat) (h_precond : countCandyDistributions_precond (n) (limit)) : Nat :=
  -- !benchmark @start code
  countCandyDistributions_efficient n limit
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_valid_distributions (n : Nat) (limit : Nat) : Nat :=
  let candidates := List.range (limit + 1)
  let valid_triples := candidates.flatMap fun x =>
    candidates.flatMap fun y =>
      let z := n - (x + y)
      if z ≤ limit ∧ x + y + z = n then
        [(x, y, z)]
      else
        []
  valid_triples.length

-- Postcondition definitions
@[reducible, simp]
def countCandyDistributions_postcond (n : Nat) (limit : Nat) (result: Nat) (h_precond : countCandyDistributions_precond (n) (limit)) : Prop :=
  -- !benchmark @start postcond
  result = count_valid_distributions n limit
  -- !benchmark @end postcond


-- Proof content
theorem countCandyDistributions_postcond_satisfied (n: Nat) (limit: Nat) (h_precond : countCandyDistributions_precond (n) (limit)) :
    countCandyDistributions_postcond (n) (limit) (countCandyDistributions (n) (limit) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof