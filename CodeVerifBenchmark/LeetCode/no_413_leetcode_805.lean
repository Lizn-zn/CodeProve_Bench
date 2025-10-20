import Mathlib

-- Precondition auxiliary definitions
/-- The sum of a list of natural numbers. -/
def List.sumNat : List Nat → Nat
  | [] => 0
  | x :: xs => x + sumNat xs

/-- Check if a list can be split into two non-empty sublists with equal averages. -/
def canSplitIntoTwoNonEmptyWithEqualAverages (nums : List Nat) : Prop :=
  ∃ A B : List Nat,
    A ≠ [] ∧ B ≠ [] ∧
    List.Perm (A ++ B) nums ∧
    (A.sumNat * B.length = B.sumNat * A.length)

-- Precondition definitions
@[reducible, simp]
def canSplitArrayWithEqualAverage_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Generate all possible non-empty sublists of a given list. -/
def nonEmptySublists {α : Type} : List α → List (List α)
  | [] => []
  | x :: xs =>
    let subs := nonEmptySublists xs
    [x] :: (subs ++ (subs.map (x :: ·)))

/-- Check if a list is a proper sublist (not equal to the original list). -/
def isProperSublist {α : Type} [DecidableEq α] (sublist : List α) (original : List α) : Bool :=
  decide (sublist ≠ original) && (sublist.length < original.length)

-- Main function definitions
def canSplitArrayWithEqualAverage (nums : List Nat) (h_precond : canSplitArrayWithEqualAverage_precond (nums)) : Bool :=
  -- !benchmark @start code
  let n := nums.length
    if n ≤ 1 then
      false
    else
      let totalSum := nums.sumNat
      let sublists := nonEmptySublists nums
      let validSublists := sublists.filter fun A =>
        let lenA := A.length
        let sumA := A.sumNat
        let lenB := n - lenA
        lenA > 0 ∧ lenB > 0 ∧ (sumA * lenB = (totalSum - sumA) * lenA)
      validSublists.length > 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def canSplitArrayWithEqualAverage_postcond (nums : List Nat) (result: Bool) (h_precond : canSplitArrayWithEqualAverage_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result ↔ canSplitIntoTwoNonEmptyWithEqualAverages nums
  -- !benchmark @end postcond


-- Proof content
theorem canSplitArrayWithEqualAverage_postcond_satisfied (nums: List Nat) (h_precond : canSplitArrayWithEqualAverage_precond (nums)) :
    canSplitArrayWithEqualAverage_postcond (nums) (canSplitArrayWithEqualAverage (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
