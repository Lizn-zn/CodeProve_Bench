import Mathlib

-- Precondition definitions
@[reducible, simp]
def sum_and_square_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def sum_and_square (nums : List Int) (h_precond : sum_and_square_precond (nums)) : Prod Int (List Int) :=
  -- !benchmark @start code
  let sum := nums.foldl (· + ·) 0
  let squared := nums.map (λ x => x * x)
  (sum, squared)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_list (nums : List Int) : Int :=
  match nums with
  | [] => 0
  | h :: t => h + sum_list t

def square_list (nums : List Int) : List Int :=
  match nums with
  | [] => []
  | h :: t => (h * h) :: square_list t

-- Postcondition definitions
@[reducible, simp]
def sum_and_square_postcond (nums : List Int) (result: Prod Int (List Int)) (h_precond : sum_and_square_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result.1 = sum_list nums ∧ result.2 = square_list nums
  -- !benchmark @end postcond


-- Proof content
theorem sum_and_square_postcond_satisfied (nums: List Int) (h_precond : sum_and_square_precond (nums)) :
    sum_and_square_postcond (nums) (sum_and_square (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

