import Mathlib

-- Precondition definitions
@[reducible, simp]
def threeConsecutiveSum_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to compute three consecutive integers that sum to `num`, if possible -/
def computeThreeConsecutive (num : Int) : List Int :=
  if num % 3 = 0 then
    let mid := num / 3
    [mid - 1, mid, mid + 1]
  else
    []

-- Main function definitions
def threeConsecutiveSum (num : Int) (h_precond : threeConsecutiveSum_precond (num)) : List Int :=
  -- !benchmark @start code
  computeThreeConsecutive num
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Checks if a list consists of exactly three consecutive integers -/
def IsThreeConsecutive (l : List Int) : Prop :=
  ∃ n : Int, l = [n, n+1, n+2]

/-- Computes the sum of elements in a list of integers -/
def ListSum : List Int → Int
  | [] => 0
  | x :: xs => x + ListSum xs

/-- Predicate indicating that the list is empty -/
def IsEmptyList (l : List Int) : Prop := l = []

-- Postcondition definitions
@[reducible, simp]
def threeConsecutiveSum_postcond (num : Int) (result: List Int) (h_precond : threeConsecutiveSum_precond (num)) : Prop :=
  -- !benchmark @start postcond
  ((num % 3 = 0) ∧ (result = [(num / 3) - 1, num / 3, (num / 3) + 1])) ∨
    ((num % 3 ≠ 0) ∧ result = [])
  -- !benchmark @end postcond


-- Proof content
theorem threeConsecutiveSum_postcond_satisfied (num: Int) (h_precond : threeConsecutiveSum_precond (num)) :
    threeConsecutiveSum_postcond (num) (threeConsecutiveSum (num) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof