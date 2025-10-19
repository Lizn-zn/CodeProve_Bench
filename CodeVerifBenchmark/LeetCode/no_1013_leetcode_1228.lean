import Mathlib

-- Precondition auxiliary definitions
/-- An arithmetic progression is a list where the difference between consecutive elements is constant -/
def IsArithmeticProgression (l : List Nat) : Prop :=
  match l with
  | [] => True
  | [_] => True
  | a :: b :: rest => 
    let diff := b - a
    ∀ i, (l.get? i).isSome ∧ (l.get? (i+1)).isSome → 
      (l.get! (i+1)) - (l.get! i) = diff

/-- A valid input array for findMissing: has at least 3 elements -/
def IsValidInputArray (arr : List Nat) : Prop :=
  arr.length ≥ 3

-- Precondition definitions
@[reducible, simp]
def findMissing_precond (arr : List Nat) : Prop :=
  -- !benchmark @start precond
  IsValidInputArray arr ∧ 
  ∃ original : List Nat, 
    IsArithmeticProgression original ∧
    arr.length = original.length - 1 ∧
    ∃ i : Nat, 0 < i ∧ i < original.length - 1 ∧
      arr = (List.take i original).append (List.drop (i+1) original)
  -- !benchmark @end precond


-- Code auxiliary definitions
/--
Calculate the common difference of an arithmetic progression from the first and last elements
and the length of the list.
-/
def calculateCommonDiff (l : List Nat) : Nat :=
  if l.length = 0 then
    0
  else
    let first := l.head!
    let last := l.getLast!
    if l.length = 1 then 0 else
      -- Since we're dealing with natural numbers, we assume the difference divides evenly
      (last - first) / (l.length - 1)

/--
Get the element at index i in the list, returning 0 if the index is out of bounds.
This is used only for valid indices in our context.
-/
def getElemD (l : List Nat) (i : Nat) : Nat :=
  match l.get? i with
  | some val => val
  | none => 0 -- Should not happen in our use cases due to preconditions

-- Main function definitions
def findMissing (arr : List Nat) (h_precond : findMissing_precond (arr)) : Nat :=
  -- !benchmark @start code
  let n := arr.length
    
    -- Calculate expected common difference from first and last elements
    -- Original array had n+1 elements
    let first := arr.head!
    let last := arr.getLast!
    let expectedDiff := (last - first) / n
    
    -- Iterate through the array to find where the difference doesn't match
    -- We check pairs of consecutive elements in arr
    -- If arr[i+1] - arr[i] ≠ expectedDiff, then the missing element is between them
    -- But since one element is missing, we need to be careful about indexing
    
    -- Let's scan for the point where the gap is twice the expected difference
    -- That means the missing element is right in the middle
    let rec findGap (i : Nat) : Nat :=
      if i + 1 ≥ arr.length then
        -- This shouldn't happen given the preconditions, but we need to satisfy the compiler
        first + expectedDiff
      else
        let current := getElemD arr i
        let next := getElemD arr (i+1)
        let actualDiff := next - current
        if actualDiff = 2 * expectedDiff then
          -- Missing element is right between current and next
          current + expectedDiff
        else if actualDiff ≠ expectedDiff then
          -- Handle decreasing sequence case
          if expectedDiff = 0 then
            current -- All elements should be the same
          else
            findGap (i + 1)
        else
          findGap (i + 1)
    
    -- Start checking from index 0
    findGap 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Check if inserting a value at a specific index in an array produces an arithmetic progression -/
def FormsArithmeticProgressionWithInsert (arr : List Nat) (index : Nat) (value : Nat) : Prop :=
  let newArr := arr.take index ++ [value] ++ arr.drop index
  IsArithmeticProgression newArr

-- Postcondition definitions
@[reducible, simp]
def findMissing_postcond (arr : List Nat) (result: Nat) (h_precond : findMissing_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  ∃ i : Nat, 0 < i ∧ i < arr.length + 1 ∧
    FormsArithmeticProgressionWithInsert arr i result
  -- !benchmark @end postcond


-- Proof content
theorem findMissing_postcond_satisfied (arr: List Nat) (h_precond : findMissing_precond (arr)) :
    findMissing_postcond (arr) (findMissing (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof