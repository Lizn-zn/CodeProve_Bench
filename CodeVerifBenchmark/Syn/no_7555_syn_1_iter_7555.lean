import Mathlib

namespace no_7555_syn_1_iter_7555


-- Precondition definitions
@[reducible, simp]
def list_to_array_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def list_to_array (lst : List Int) (h_precond : list_to_array_precond (lst)) : Array Int :=
  -- !benchmark @start code
  let rec loop (arr : Array Int) (remaining : List Int) : Array Int :=
    match remaining with
    | [] => arr
    | x :: xs => loop (arr.push x) xs
  loop (Array.mkEmpty lst.length) lst
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def list_to_array_postcond (lst : List Int) (result: Array Int) (h_precond : list_to_array_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result.toList = lst
  -- !benchmark @end postcond


-- Proof content
theorem list_to_array_postcond_satisfied (lst: List Int) (h_precond : list_to_array_precond (lst)) :
    list_to_array_postcond (lst) (list_to_array (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7555_syn_1_iter_7555