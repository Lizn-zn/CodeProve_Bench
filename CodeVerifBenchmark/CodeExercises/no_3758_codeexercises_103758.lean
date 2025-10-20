import Mathlib

namespace no_3758_codeexercises_103758


-- Precondition definitions
@[reducible, simp]
def count_true_values_precond (lst : List Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def count_true_values (lst : List Bool) (h_precond : count_true_values_precond (lst)) : Nat :=
  -- !benchmark @start code
  match lst with
    | [] => 0
    | true :: xs => 1 + count_true_values xs h_precond
    | false :: xs => count_true_values xs h_precond
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def count_true_values_postcond (lst : List Bool) (result: Nat) (h_precond : count_true_values_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = (lst.filter (λ x => x)).length
  -- !benchmark @end postcond


-- Proof content
theorem count_true_values_postcond_satisfied (lst: List Bool) (h_precond : count_true_values_precond (lst)) :
    count_true_values_postcond (lst) (count_true_values (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3758_codeexercises_103758