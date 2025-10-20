import Mathlib

namespace no_2158_p03139


-- Precondition definitions
@[reducible, simp]
def newspaperSubscription_precond (N : Nat) (A : Nat) (B : Nat) : Prop :=
  -- !benchmark @start precond
  -- N is the total number of respondents
    -- A is the number of respondents subscribing to Newspaper X
    -- B is the number of respondents subscribing to Newspaper Y
    -- Constraints from the problem
    1 ≤ N ∧ N ≤ 100 ∧
    0 ≤ A ∧ A ≤ N ∧
    0 ≤ B ∧ B ≤ N
  -- !benchmark @end precond


-- Main function definitions
def newspaperSubscription (N : Nat) (A : Nat) (B : Nat) (h_precond : newspaperSubscription_precond (N) (A) (B)) : Nat × Nat :=
  -- !benchmark @start code
  let max_both := min A B
  let min_both := max 0 (A + B - N)
  (max_both, min_both)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def newspaperSubscription_postcond (N : Nat) (A : Nat) (B : Nat) (result: Nat × Nat) (h_precond : newspaperSubscription_precond (N) (A) (B)) : Prop :=
  -- !benchmark @start postcond
  -- result.1 is the maximum possible number of respondents subscribing to both newspapers
    -- result.2 is the minimum possible number of respondents subscribing to both newspapers
    let max_both := min A B
    let min_both := max 0 (A + B - N)
    result.1 = max_both ∧ result.2 = min_both ∧
    -- The maximum is bounded by the minimum of A and B (can't have more subscribers to both than subscribers to either)
    max_both ≤ A ∧ max_both ≤ B ∧
    -- The minimum is at least 0
    0 ≤ min_both ∧
    -- By inclusion-exclusion principle: |X ∪ Y| = |X| + |Y| - |X ∩ Y|
    -- Since |X ∪ Y| ≤ N, we have |X ∩ Y| ≥ A + B - N
    -- And since |X ∩ Y| ≥ 0, we have min_both = max(0, A + B - N)
    min_both ≤ max_both
  -- !benchmark @end postcond


-- Proof content
theorem newspaperSubscription_postcond_satisfied (N: Nat) (A: Nat) (B: Nat) (h_precond : newspaperSubscription_precond (N) (A) (B)) :
    newspaperSubscription_postcond (N) (A) (B) (newspaperSubscription (N) (A) (B) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2158_p03139