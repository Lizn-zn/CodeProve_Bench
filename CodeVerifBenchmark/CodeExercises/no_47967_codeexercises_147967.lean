import Mathlib

namespace no_47967_codeexercises_147967


-- Precondition definitions
@[reducible, simp]
def athlete_performance_precond (scores : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def athlete_performance (scores : List Nat) (h_precond : athlete_performance_precond (scores)) : List Nat :=
  -- !benchmark @start code
  if scores.isEmpty then
    []
  else
    let avg := scores.sum / scores.length
    scores.filter (λ score => score ≥ avg)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def average (scores : List Nat) : Nat :=
  if scores.isEmpty then 0
  else (scores.sum) / scores.length

def is_above_average (score : Nat) (scores : List Nat) : Bool :=
  score ≥ average scores

-- Postcondition definitions
@[reducible, simp]
def athlete_performance_postcond (scores : List Nat) (result: List Nat) (h_precond : athlete_performance_precond (scores)) : Prop :=
  -- !benchmark @start postcond
  result = scores.filter (λ score => is_above_average score scores)
  -- !benchmark @end postcond


-- Proof content
theorem athlete_performance_postcond_satisfied (scores: List Nat) (h_precond : athlete_performance_precond (scores)) :
    athlete_performance_postcond (scores) (athlete_performance (scores) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_47967_codeexercises_147967