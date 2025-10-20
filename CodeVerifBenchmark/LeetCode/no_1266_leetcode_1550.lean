import Mathlib

namespace no_1266_leetcode_1550


-- Precondition auxiliary definitions
def IsOdd (n : Int) : Prop := n % 2 == 1

def HasThreeConsecutiveOdds (arr : Array Int) : Prop :=
  ∃ i : Nat, i + 2 < arr.size ∧ IsOdd (arr[i]!) ∧ IsOdd (arr[i+1]!) ∧ IsOdd (arr[i+2]!)

-- Precondition definitions
@[reducible, simp]
def threeConsecutiveOdds_precond (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def checkThreeConsecutiveOdds (arr : Array Int) (i : Nat) : Bool :=
  if i + 2 < arr.size then
    (arr[i]! % 2 == 1) && (arr[i+1]! % 2 == 1) && (arr[i+2]! % 2 == 1)
  else
    false

-- Main function definitions
def threeConsecutiveOdds (arr : Array Int) (h_precond : threeConsecutiveOdds_precond (arr)) : Bool :=
  -- !benchmark @start code
  let rec loop (i : Nat) : Bool :=
    if i ≥ arr.size then
      false
    else if checkThreeConsecutiveOdds arr i then
      true
    else
      loop (i+1)
  loop 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def threeConsecutiveOdds_postcond (arr : Array Int) (result: Bool) (h_precond : threeConsecutiveOdds_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ HasThreeConsecutiveOdds arr
  -- !benchmark @end postcond


-- Proof content
theorem threeConsecutiveOdds_postcond_satisfied (arr: Array Int) (h_precond : threeConsecutiveOdds_precond (arr)) :
    threeConsecutiveOdds_postcond (arr) (threeConsecutiveOdds (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1266_leetcode_1550