import Mathlib

namespace no_16163_codeexercises_24825


-- Precondition definitions
@[reducible, simp]
def filter_and_count_names_precond (names : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def filter_and_count_names (names : List String) (h_precond : filter_and_count_names_precond (names)) : Nat :=
  -- !benchmark @start code
  let rec loop (count : Nat) (remaining : List String) : Nat :=
    match remaining with
    | [] => count
    | name :: rest =>
      if name.startsWith "A" || name.endsWith "y" then
        loop count rest
      else
        loop (count + 1) rest
  loop 0 names
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def should_filter (name : String) : Bool :=
  name.startsWith "A" || name.endsWith "y"

-- Postcondition definitions
@[reducible, simp]
def filter_and_count_names_postcond (names : List String) (result: Nat) (h_precond : filter_and_count_names_precond (names)) : Prop :=
  -- !benchmark @start postcond
  result = (names.filter (λ name => ¬ should_filter name)).length
  -- !benchmark @end postcond


-- Proof content
theorem filter_and_count_names_postcond_satisfied (names: List String) (h_precond : filter_and_count_names_precond (names)) :
    filter_and_count_names_postcond (names) (filter_and_count_names (names) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_16163_codeexercises_24825