import Mathlib

namespace no_1335_leetcode_2659


-- Precondition auxiliary definitions
def sortedWithIndex (nums : List Int) : List (Int × Nat) :=
  let indexed := List.zip nums (List.range nums.length)
  indexed.mergeSort (fun a b => a.1 < b.1 || (a.1 == b.1 && a.2 < b.2))

def countOperationsToEmptyArray_compute (nums : List Int) : Nat :=
  if nums = [] then 0 else
  let sortedIndexed := sortedWithIndex nums
  let positions := sortedIndexed.map (·.2)
  let n := nums.length
  let rec go (posList : List Nat) (acc : Nat) (base : Nat) : Nat :=
    match posList with
    | [] => acc
    | p :: ps =>
      let steps := if ps.isEmpty then
                     if p ≥ base then p - base + 1
                     else (n - base) + p + 1
                   else
                     if p ≥ base then p - base + 1
                     else (n - base) + p + 1
      let newBase := (p + 1) % n
      go ps (acc + steps) newBase
  go positions 0 0

-- Precondition definitions
@[reducible, simp]
def countOperationsToEmptyArray_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- Code auxiliary definitions
def getElementPositionsSorted (nums : List Int) : List Nat :=
  let indexed := List.zip (List.range nums.length) nums
  let sorted := indexed.mergeSort (fun a b => a.2 < b.2 || (a.2 == b.2 && a.1 < b.1))
  sorted.map (·.1)

def countInversionsAfter (positions : List Nat) : Nat :=
  let rec countInv (lst : List Nat) : Nat :=
    match lst with
    | [] => 0
    | x :: xs =>
      let invHere := xs.filter (· < x) |>.length
      invHere + countInv xs
  countInv positions

-- Main function definitions
def countOperationsToEmptyArray (nums : List Int) (h_precond : countOperationsToEmptyArray_precond (nums)) : Nat :=
  -- !benchmark @start code
  let n := nums.length
  if n = 0 then 0 else
  let sortedPositions := getElementPositionsSorted nums
  let inversions := countInversionsAfter sortedPositions
  n + inversions
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def countOperationsToEmptyArray_postcond (nums : List Int) (result: Nat) (h_precond : countOperationsToEmptyArray_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = countOperationsToEmptyArray_compute nums
  -- !benchmark @end postcond

-- Proof content
theorem countOperationsToEmptyArray_postcond_satisfied (nums: List Int) (h_precond : countOperationsToEmptyArray_precond (nums)) :
    countOperationsToEmptyArray_postcond (nums) (countOperationsToEmptyArray (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1335_leetcode_2659