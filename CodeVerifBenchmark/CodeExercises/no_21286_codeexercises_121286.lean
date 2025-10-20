import Mathlib

namespace no_21286_codeexercises_121286


-- Precondition definitions
@[reducible, simp]
def append_positive_elevations_precond (elevations : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the code implementation

-- Main function definitions
def append_positive_elevations (elevations : List Int) (h_precond : append_positive_elevations_precond (elevations)) : List Int :=
  -- !benchmark @start code
  let rec loop (input : List Int) (output : List Int) : List Int :=
    match input with
    | [] => output.reverse
    | h :: t =>
      if h > 0 then
        loop t (h :: output)
      else
        loop t output
  loop elevations []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filter_positive (l : List Int) : List Int :=
  l.filter (λ x => x > 0)

-- Postcondition definitions
@[reducible, simp]
def append_positive_elevations_postcond (elevations : List Int) (result: List Int) (h_precond : append_positive_elevations_precond (elevations)) : Prop :=
  -- !benchmark @start postcond
  result = filter_positive elevations
  -- !benchmark @end postcond


-- Proof content
theorem append_positive_elevations_postcond_satisfied (elevations: List Int) (h_precond : append_positive_elevations_precond (elevations)) :
    append_positive_elevations_postcond (elevations) (append_positive_elevations (elevations) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_21286_codeexercises_121286