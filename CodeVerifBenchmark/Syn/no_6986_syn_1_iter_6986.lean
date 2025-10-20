import Mathlib

namespace no_6986_syn_1_iter_6986


-- Precondition definitions
@[reducible, simp]
def string_lengths_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def string_lengths (strings : List String) (h_precond : string_lengths_precond (strings)) : List Nat :=
  -- !benchmark @start code
  match strings with
    | [] => []
    | s :: rest => s.length :: string_lengths rest h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def string_lengths_postcond (strings : List String) (result: List Nat) (h_precond : string_lengths_precond (strings)) : Prop :=
  -- !benchmark @start postcond
  result = strings.map String.length
  -- !benchmark @end postcond


-- Proof content
theorem string_lengths_postcond_satisfied (strings: List String) (h_precond : string_lengths_precond (strings)) :
    string_lengths_postcond (strings) (string_lengths (strings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6986_syn_1_iter_6986