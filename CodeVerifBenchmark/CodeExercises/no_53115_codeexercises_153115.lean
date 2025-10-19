import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_positives_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def count_positives (numbers : List Int) (h_precond : count_positives_precond (numbers)) : Nat :=
  -- !benchmark @start code
  let rec loop (nums : List Int) (count : Nat) : Nat :=
    match nums with
    | [] => count
    | x :: xs =>
      if x < 0 then count
      else if x == 0 then loop xs count
      else loop xs (count + 1)
  loop numbers 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_positives_aux (numbers : List Int) : Nat :=
  match numbers with
  | [] => 0
  | x :: xs =>
    if x < 0 then 0
    else if x == 0 then count_positives_aux xs
    else 1 + count_positives_aux xs

-- Postcondition definitions
@[reducible, simp]
def count_positives_postcond (numbers : List Int) (result: Nat) (h_precond : count_positives_precond (numbers)) : Prop :=
  -- !benchmark @start postcond
  result = count_positives_aux numbers
  -- !benchmark @end postcond


-- Proof content
theorem count_positives_postcond_satisfied (numbers: List Int) (h_precond : count_positives_precond (numbers)) :
    count_positives_postcond (numbers) (count_positives (numbers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

