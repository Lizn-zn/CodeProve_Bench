import Mathlib

namespace no_73075_codeexercises_173075


-- Precondition definitions
@[reducible, simp]
def find_longest_movie_length_precond (movies : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to find the maximum length in a list of strings -/
def max_length_aux : List String → Nat → Nat
  | [], maxSoFar => maxSoFar
  | m :: ms, maxSoFar => max_length_aux ms (max m.length maxSoFar)

-- Main function definitions
def find_longest_movie_length (movies : List String) (h_precond : find_longest_movie_length_precond (movies)) : Nat :=
  -- !benchmark @start code
  match movies with
  | [] => 0
  | m :: ms => max_length_aux ms m.length
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def max_length (movies : List String) : Nat :=
  match movies with
  | [] => 0
  | m :: ms => max m.length (max_length ms)

-- Postcondition definitions
@[reducible, simp]
def find_longest_movie_length_postcond (movies : List String) (result: Nat) (h_precond : find_longest_movie_length_precond (movies)) : Prop :=
  -- !benchmark @start postcond
  result = max_length movies
  -- !benchmark @end postcond


-- Proof content
theorem find_longest_movie_length_postcond_satisfied (movies: List String) (h_precond : find_longest_movie_length_precond (movies)) :
    find_longest_movie_length_postcond (movies) (find_longest_movie_length (movies) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_73075_codeexercises_173075