import Mathlib

-- Precondition auxiliary definitions
def List.countZeros (l : List Nat) : Nat :=
  l.filter (· = 0) |>.length

def List.nonzeroElements (l : List Nat) : List Nat :=
  l.filter (· ≠ 0)

def List.applyOps (nums : List Nat) : List Nat :=
  match nums with
  | [] => []
  | [_] => nums
  | a :: b :: rest =>
    if a = b then
      (2 * a) :: 0 :: (List.applyOps rest)
    else
      a :: (List.applyOps (b :: rest))

-- Precondition definitions
@[reducible, simp]
def applyOperationsAndShiftZeros_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  nums.length ≥ 2
  -- !benchmark @end precond


-- Code auxiliary definitions
def shiftZerosToEnd (l : List Nat) : List Nat :=
  let nonzero := l.filter (· ≠ 0)
  let zeros := l.filter (· = 0)
  nonzero ++ zeros

-- Main function definitions
def applyOperationsAndShiftZeros (nums : List Nat) (h_precond : applyOperationsAndShiftZeros_precond (nums)) : List Nat :=
  -- !benchmark @start code
  let processed := List.applyOps nums
  shiftZerosToEnd processed
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed here

-- Postcondition definitions
@[reducible, simp]
def applyOperationsAndShiftZeros_postcond (nums : List Nat) (result: List Nat) (h_precond : applyOperationsAndShiftZeros_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let processed := List.applyOps nums
    let nonzero := List.nonzeroElements processed
    let zeroCount := List.countZeros processed
    let expectedZeros := List.replicate zeroCount 0
    result = nonzero ++ expectedZeros ∧
    result.length = nums.length ∧
    List.countZeros result = List.countZeros nums ∧
    List.nonzeroElements result = List.nonzeroElements nums
  -- !benchmark @end postcond


-- Proof content
theorem applyOperationsAndShiftZeros_postcond_satisfied (nums: List Nat) (h_precond : applyOperationsAndShiftZeros_precond (nums)) :
    applyOperationsAndShiftZeros_postcond (nums) (applyOperationsAndShiftZeros (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

