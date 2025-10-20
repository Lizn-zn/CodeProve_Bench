import Mathlib

namespace no_19587_codeexercises_119587


-- Precondition definitions
@[reducible, simp]
def dancer_moves_precond (dancers : List (List String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def dancer_moves (dancers : List (List String)) (h_precond : dancer_moves_precond (dancers)) : List String :=
  -- !benchmark @start code
  match dancers with
  | [] => []
  | head :: tail =>
    let rec loop (acc : List String) (remaining : List (List String)) : List String :=
      match remaining with
      | [] => acc
      | current :: rest =>
        let filtered_acc := acc.filter (λ x => current.contains x)
        loop filtered_acc rest
    loop head tail
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def intersection_of_lists (lists : List (List String)) : List String :=
  match lists with
  | [] => []
  | head :: tail => tail.foldl (λ acc l => acc.filter (λ x => l.contains x)) head

-- Postcondition definitions
@[reducible, simp]
def dancer_moves_postcond (dancers : List (List String)) (result: List String) (h_precond : dancer_moves_precond (dancers)) : Prop :=
  -- !benchmark @start postcond
  result = intersection_of_lists dancers
  -- !benchmark @end postcond


-- Proof content
theorem dancer_moves_postcond_satisfied (dancers: List (List String)) (h_precond : dancer_moves_precond (dancers)) :
    dancer_moves_postcond (dancers) (dancer_moves (dancers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_19587_codeexercises_119587