import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_positive_numbers_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def sum_positive_numbers (numbers : List Int) (h_precond : sum_positive_numbers_precond (numbers)) : Int :=
  -- !benchmark @start code
  let rec loop (nums : List Int) (acc : Int) : Int :=
    match nums with
    | [] => acc
    | x :: xs => 
      if x > 0 then
        loop xs (acc + x)
      else
        loop xs acc
  loop numbers 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_positive (numbers : List Int) : Int :=
  numbers.filter (λ x => x > 0) |>.foldl (· + ·) 0

-- Postcondition definitions
@[reducible, simp]
def sum_positive_numbers_postcond (numbers : List Int) (result: Int) (h_precond : sum_positive_numbers_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = sum_positive numbers
  -- !benchmark @end postcond


-- Proof content
theorem sum_positive_numbers_postcond_satisfied (numbers: List Int) (h_precond : sum_positive_numbers_precond (numbers)) :
    sum_positive_numbers_postcond (numbers) (sum_positive_numbers (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

