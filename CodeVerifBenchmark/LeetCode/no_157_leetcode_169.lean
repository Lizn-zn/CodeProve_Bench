import Mathlib

-- Precondition auxiliary definitions
def count_occurrences (nums : Array Int) (x : Int) : Nat :=
  nums.foldl (fun acc elem => if elem = x then acc + 1 else acc) 0

def is_majority_element (nums : Array Int) (x : Int) : Prop :=
  let n := nums.size
  count_occurrences nums x > n / 2

-- Precondition definitions
@[reducible, simp]
def majorityElement_precond (nums : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def find_candidate (nums : Array Int) : Int :=
  let (_, candidate) := nums.foldl (fun (count, cand) elem =>
    if count = 0 then
      (1, elem)
    else if elem = cand then
      (count + 1, cand)
    else
      (count - 1, cand)
  ) (0, 0)
  candidate

-- Main function definitions
def majorityElement (nums : Array Int) (h_precond : majorityElement_precond (nums)) : Int :=
  -- !benchmark @start code
  let candidate := find_candidate nums
  candidate
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for the postcondition

-- Postcondition definitions
@[reducible, simp]
def majorityElement_postcond (nums : Array Int) (result: Int) (h_precond : majorityElement_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  is_majority_element nums result
  -- !benchmark @end postcond


-- Proof content
theorem majorityElement_postcond_satisfied (nums: Array Int) (h_precond : majorityElement_precond (nums)) :
    majorityElement_postcond (nums) (majorityElement (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

