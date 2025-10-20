import Mathlib

namespace no_12699_codeexercises_19476


-- Precondition definitions
@[reducible, simp]
def absolute_difference_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def absolute_difference (numbers : List Int) (h_precond : absolute_difference_precond (numbers)) : List Int :=
  -- !benchmark @start code
  match numbers with
  | [] => []
  | [_] => []
  | x :: y :: rest => 
    let diff := Int.natAbs (y - x)
    diff :: absolute_difference (y :: rest) h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def absolute_differences (numbers : List Int) : List Int :=
  match numbers with
  | [] => []
  | [_] => []
  | x :: y :: rest => 
    let diff := Int.natAbs (y - x)
    diff :: absolute_differences (y :: rest)

-- Postcondition definitions
@[reducible, simp]
def absolute_difference_postcond (numbers : List Int) (result: List Int) (h_precond : absolute_difference_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = absolute_differences numbers
  -- !benchmark @end postcond


-- Proof content
theorem absolute_difference_postcond_satisfied (numbers: List Int) (h_precond : absolute_difference_precond (numbers)) :
    absolute_difference_postcond (numbers) (absolute_difference (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_12699_codeexercises_19476