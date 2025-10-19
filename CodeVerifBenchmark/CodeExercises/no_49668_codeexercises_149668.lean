import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_actors_with_high_ratings_precond (actors : List String) (ratings : List Float) (threshold : Float) : Prop :=
  -- !benchmark @start precond
  actors.length = ratings.length ∧ threshold > 0
  -- !benchmark @end precond


-- Main function definitions
def find_actors_with_high_ratings (actors : List String) (ratings : List Float) (threshold : Float) (h_precond : find_actors_with_high_ratings_precond (actors) (ratings) (threshold)) : List String :=
  -- !benchmark @start code
  let rec loop (i : Nat) (result : List String) : List String :=
    if h : i < actors.length then
      have h_ratings : i < ratings.length := by
        rw [show actors.length = ratings.length from h_precond.left] at h
        exact h
      if ratings.get ⟨i, h_ratings⟩ > threshold then
        loop (i + 1) (actors.get ⟨i, h⟩ :: result)
      else
        loop (i + 1) result
    else
      result.reverse
  loop 0 []
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_actors_with_high_ratings_postcond (actors : List String) (ratings : List Float) (threshold : Float) (result: List String) (h_precond : find_actors_with_high_ratings_precond (actors) (ratings) (threshold)) : Prop :=
  -- !benchmark @start postcond
  result = ((actors.zip ratings).filter (λ p => p.2 > threshold)).map Prod.fst
  -- !benchmark @end postcond


-- Proof content
theorem find_actors_with_high_ratings_postcond_satisfied (actors: List String) (ratings: List Float) (threshold: Float) (h_precond : find_actors_with_high_ratings_precond (actors) (ratings) (threshold)) :
    find_actors_with_high_ratings_postcond (actors) (ratings) (threshold) (find_actors_with_high_ratings (actors) (ratings) (threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof