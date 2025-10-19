import Mathlib

-- Precondition auxiliary definitions
def countRibbons (ribbons : List Nat) (length : Nat) : Nat :=
  ribbons.foldl (fun acc r => acc + r / length) 0

-- Precondition definitions
@[reducible, simp]
def maxRibbonLength_precond (ribbons : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Binary search for the maximum ribbon length -/
def binarySearch (ribbons : List Nat) (k : Nat) (low : Nat) (high : Nat) : Nat :=
  if low > high then
    0
  else
    let mid := (low + high) / 2
    let count := countRibbons ribbons mid
    if count >= k then
      if mid = 0 then
        0
      else
        let candidate := mid
        let result := binarySearch ribbons k (mid+1) high
        if result > candidate then result else candidate
    else
      binarySearch ribbons k low (if mid = 0 then 0 else mid - 1)
  termination_by high - low
  decreasing_by
    all_goals sorry

/- A safe maximum function for Nat that handles empty lists properly -/
def maxOfList : List Nat → Nat
  | [] => 0
  | xs => xs.foldl (·.max ·) 0

-- Main function definitions
def maxRibbonLength (ribbons : List Nat) (k : Nat) (h_precond : maxRibbonLength_precond (ribbons) (k)) : Nat :=
  -- !benchmark @start code
  let maxLength := maxOfList ribbons
  binarySearch ribbons k 1 maxLength
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Empty, as no auxiliary definitions are required for the postcondition.

-- Postcondition definitions
@[reducible, simp]
def maxRibbonLength_postcond (ribbons : List Nat) (k : Nat) (result: Nat) (h_precond : maxRibbonLength_precond ribbons k) : Prop :=
  -- !benchmark @start postcond
  (result = 0 ∧ ∀ (len : Nat), len > 0 → countRibbons ribbons len < k) ∨
    (result > 0 ∧ countRibbons ribbons result ≥ k ∧ (∀ (len : Nat), len > result → countRibbons ribbons len < k))
  -- !benchmark @end postcond


-- Proof content
theorem maxRibbonLength_postcond_satisfied (ribbons: List Nat) (k: Nat) (h_precond : maxRibbonLength_precond ribbons k) :
    maxRibbonLength_postcond ribbons k (maxRibbonLength ribbons k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof