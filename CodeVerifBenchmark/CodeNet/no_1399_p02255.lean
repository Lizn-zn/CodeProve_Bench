import Mathlib

-- Precondition definitions
@[reducible, simp]
def insertionSort_precond (A : Array Nat) (N : Nat) : Prop :=
  -- !benchmark @start precond
  N = A.size
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to insert an element into the sorted portion of the array
def insertElement (arr : Array Nat) (i : Nat) : Array Nat :=
  if i = 0 then arr
  else
    let key := arr[i]!
    let rec insert (a : Array Nat) (j : Nat) (fuel : Nat) : Array Nat :=
      match fuel with
      | 0 => a
      | fuel' + 1 =>
        if j = 0 then
          if a[j]! > key then
            a.set! (j + 1) key
          else
            a
        else
          if a[j]! > key then
            let a' := a.set! (j + 1) a[j]!
            insert a' (j - 1) fuel'
          else
            a.set! (j + 1) key
    insert arr (i - 1) i

-- Main function definitions
def insertionSort (A : Array Nat) (N : Nat) (h_precond : insertionSort_precond (A) (N)) : Array (Array Nat) :=
  -- !benchmark @start code
  -- Build result array by accumulating intermediate states
    let rec loop (i : Nat) (current : Array Nat) (result : Array (Array Nat)) (fuel : Nat) : Array (Array Nat) :=
      match fuel with
      | 0 => result
      | fuel' + 1 =>
        if i >= N then
          result
        else
          -- Add current state to result
          let result' := result.push current
          -- Perform insertion for next iteration
          let next := if i + 1 < N then insertElement current (i + 1) else current
          loop (i + 1) next result' fuel'
    
    -- Start with initial array at i=0
    loop 0 A #[] N
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Check if array is sorted up to index k
def isSortedUpTo (arr : Array Nat) (k : Nat) : Prop :=
  ∀ i j, i < j → j ≤ k → i < arr.size → j < arr.size → arr[i]! ≤ arr[j]!

-- Check if array b is a permutation of array a
def isPermutation (a b : Array Nat) : Prop :=
  a.size = b.size ∧ 
  ∀ x, (a.toList.count x) = (b.toList.count x)

-- Postcondition definitions
@[reducible, simp]
def insertionSort_postcond (A : Array Nat) (N : Nat) (result: Array (Array Nat)) (h_precond : insertionSort_precond (A) (N)) : Prop :=
  -- !benchmark @start postcond
  -- The result has exactly N steps (one for each iteration from i=0 to i=N-1)
    result.size = N ∧
    -- First step shows the initial array
    (N > 0 → result[0]! = A) ∧
    -- Each subsequent step is valid
    (∀ i, i < N → 
      -- Each intermediate result has the same size as A
      result[i]!.size = A.size ∧
      -- Each intermediate result is a permutation of A
      isPermutation A result[i]! ∧
      -- After step i, the first i+1 elements are sorted
      isSortedUpTo result[i]! i) ∧
    -- The final result is fully sorted
    (N > 0 → isSortedUpTo result[N-1]! (A.size - 1))
  -- !benchmark @end postcond


-- Proof content
theorem insertionSort_postcond_satisfied (A: Array Nat) (N: Nat) (h_precond : insertionSort_precond (A) (N)) :
    insertionSort_postcond (A) (N) (insertionSort (A) (N) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

