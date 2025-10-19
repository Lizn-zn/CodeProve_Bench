import Mathlib

-- Precondition auxiliary definitions
def IsSorted (a : Array Int) : Prop :=
  ∀ i j, 0 ≤ i → i ≤ j → j < a.size → a[i]! ≤ a[j]!

def IsSubarraySorted (a : Array Int) (l r : Nat) : Prop :=
  IsSorted (Array.extract a l r)

def SubarraySortsArray (a : Array Int) (l r : Nat) : Prop :=
  let sorted := (Array.extract a 0 l).append (((Array.extract a l r).qsort (· ≤ ·)).append (Array.extract a r a.size))
  IsSorted sorted

-- Precondition definitions
@[reducible, simp]
def findUnsortedSubarray_precond (nums : Array Int) : Prop :=
  -- !benchmark @start precond
  0 < nums.size
  -- !benchmark @end precond


-- Code auxiliary definitions
def findLeftBoundary (a : Array Int) : Nat :=
  let rec go (i : Nat) (maxSoFar : Int) :=
    if h : i < a.size then
      if a[i]! < maxSoFar then
        go (i + 1) maxSoFar
      else
        go (i + 1) (max maxSoFar a[i]!)
    else
      i
  go 0 a[0]!

def findRightBoundary (a : Array Int) : Nat :=
  let rec go (i : Nat) (minSoFar : Int) :=
    if h : 0 < i then
      if minSoFar < a[i-1]! then
        go (i - 1) minSoFar
      else
        go (i - 1) (min minSoFar a[i-1]!)
    else
      i
  go a.size a[a.size-1]!

def findUnsortedLeft (a : Array Int) (rightBound : Nat) : Nat :=
  let rec go (i : Nat) :=
    if h : i < rightBound then
      if a[i]! ≤ a[rightBound]! then
        go (i + 1)
      else
        i
    else
      i
  go 0

def findUnsortedRight (a : Array Int) (leftBound : Nat) : Nat :=
  let rec go (i : Nat) :=
    if h : leftBound < i then
      if a[leftBound]! ≤ a[i]! then
        go (i - 1)
      else
        i
    else
      i
  go (a.size - 1)

-- Main function definitions
def findUnsortedSubarray (nums : Array Int) (h_precond : findUnsortedSubarray_precond (nums)) : Nat :=
  -- !benchmark @start code
  let leftBound := findLeftBoundary nums
  let rightBound := findRightBoundary nums
  if leftBound ≥ nums.size ∨ rightBound = 0 then
    0
  else
    let actualLeft := findUnsortedLeft nums (rightBound - 1)
    let actualRight := findUnsortedRight nums (leftBound + 1)
    if actualLeft < actualRight then
      actualRight - actualLeft + 1
    else
      0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def findUnsortedSubarray_postcond (nums : Array Int) (result: Nat) (h_precond : findUnsortedSubarray_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  (result = 0 ∧ IsSorted nums) ∨
    (∃ l r : Nat,
      0 ≤ l ∧ l < r ∧ r ≤ nums.size ∧
      result = r - l ∧
      SubarraySortsArray nums l r ∧
      ∀ l' r' : Nat, 0 ≤ l' → l' < r' → r' ≤ nums.size → SubarraySortsArray nums l' r' → r - l ≤ r' - l')
  -- !benchmark @end postcond


-- Proof content
theorem findUnsortedSubarray_postcond_satisfied (nums: Array Int) (h_precond : findUnsortedSubarray_precond (nums)) :
    findUnsortedSubarray_postcond (nums) (findUnsortedSubarray (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof