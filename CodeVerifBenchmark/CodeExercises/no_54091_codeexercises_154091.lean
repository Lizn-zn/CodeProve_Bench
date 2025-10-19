import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_average_score_precond (athlete_scores : List Float) : Prop :=
  -- !benchmark @start precond
  ∀ score ∈ athlete_scores, 0 ≤ score ∧ score ≤ 10
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def calculate_average_score (athlete_scores : List Float) (h_precond : calculate_average_score_precond (athlete_scores)) : Float :=
  -- !benchmark @start code
  if athlete_scores.isEmpty then
    0
  else
    let total := List.sum athlete_scores
    let count := List.length athlete_scores
    let average := total / Float.ofNat count
    let rounded := Float.round (average * 100) / 100
    rounded
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def calculate_average_score_postcond (athlete_scores : List Float) (result: Float) (h_precond : calculate_average_score_precond (athlete_scores)) : Prop :=
  -- !benchmark @start postcond
  let total := List.sum athlete_scores
  let count := List.length athlete_scores
  if count = 0 then result = 0 else result = Float.round (total / Float.ofNat count * 100) / 100
  -- !benchmark @end postcond


-- Proof content
theorem calculate_average_score_postcond_satisfied (athlete_scores: List Float) (h_precond : calculate_average_score_precond (athlete_scores)) :
    calculate_average_score_postcond (athlete_scores) (calculate_average_score (athlete_scores) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof