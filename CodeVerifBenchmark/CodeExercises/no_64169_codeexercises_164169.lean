import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_squares_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Main function definitions
def sum_squares (numbers : List Int) (h_precond : sum_squares_precond (numbers)) : Int :=
  -- !benchmark @start code
  match numbers with
    | [] => 0
    | hd :: tl => hd * hd + sum_squares tl h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_squares_aux (numbers : List Int) : Int :=
  match numbers with
  | [] => 0
  | hd :: tl => hd * hd + sum_squares_aux tl

-- Postcondition definitions
@[reducible, simp]
def sum_squares_postcond (numbers : List Int) (result: Int) (h_precond : sum_squares_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = sum_squares_aux numbers
  -- !benchmark @end postcond


-- Proof content
theorem sum_squares_postcond_satisfied (numbers: List Int) (h_precond : sum_squares_precond (numbers)) :
    sum_squares_postcond (numbers) (sum_squares (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

