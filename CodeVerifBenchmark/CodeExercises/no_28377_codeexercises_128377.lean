import Mathlib

namespace no_28377_codeexercises_128377


-- Precondition definitions
@[reducible, simp]
def calculate_sum_of_positive_numbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def calculate_sum_of_positive_numbers (numbers : List Int) (h_precond : calculate_sum_of_positive_numbers_precond (numbers)) : Int :=
  -- !benchmark @start code
  numbers.foldl (λ sum num => if num > 0 then sum + num else sum) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_of_positives (numbers : List Int) : Int :=
  numbers.filter (λ x => x > 0) |>.foldl (λ acc x => acc + x) 0

-- Postcondition definitions
@[reducible, simp]
def calculate_sum_of_positive_numbers_postcond (numbers : List Int) (result: Int) (h_precond : calculate_sum_of_positive_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = sum_of_positives numbers
  -- !benchmark @end postcond


-- Proof content
theorem calculate_sum_of_positive_numbers_postcond_satisfied (numbers: List Int) (h_precond : calculate_sum_of_positive_numbers_precond (numbers)) :
    calculate_sum_of_positive_numbers_postcond (numbers) (calculate_sum_of_positive_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_28377_codeexercises_128377