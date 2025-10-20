import Mathlib

namespace no_32056_codeexercises_132056


-- Precondition definitions
@[reducible, simp]
def find_sum_of_negatives_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_sum_of_negatives (lst : List Int) (h_precond : find_sum_of_negatives_precond (lst)) : Int :=
  -- !benchmark @start code
  let rec helper (lst : List Int) (acc : Int) : Int :=
    match lst with
    | [] => acc
    | x :: xs =>
      if x < 0 then
        helper xs (acc + x)
      else
        helper xs acc
  helper lst 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_of_negatives (lst : List Int) : Int :=
  lst.filter (λ x => x < 0) |>.foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def find_sum_of_negatives_postcond (lst : List Int) (result: Int) (h_precond : find_sum_of_negatives_precond (lst)) : Prop :=
  -- !benchmark @start postcond
  result = sum_of_negatives lst
  -- !benchmark @end postcond


-- Proof content
theorem find_sum_of_negatives_postcond_satisfied (lst: List Int) (h_precond : find_sum_of_negatives_precond (lst)) :
    find_sum_of_negatives_postcond (lst) (find_sum_of_negatives (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_32056_codeexercises_132056