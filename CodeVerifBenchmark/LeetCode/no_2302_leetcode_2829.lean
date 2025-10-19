import Mathlib

-- Precondition auxiliary definitions
/-- A predicate stating that a list of natural numbers is k-avoiding, i.e.,
  there do not exist two distinct elements in the list that sum to k. -/
def IsKAvoiding (k : Nat) (arr : List Nat) : Prop :=
  ∀ (i j : Nat), i < arr.length → j < arr.length → i ≠ j → arr[i]! + arr[j]! ≠ k

/-- A predicate stating that a list of natural numbers consists of distinct positive integers. -/
def DistinctPositiveIntegers (arr : List Nat) : Prop :=
  (∀ i, i < arr.length → arr[i]! > 0) ∧
  (∀ i j, i < arr.length → j < arr.length → i ≠ j → arr[i]! ≠ arr[j]!)

-- Precondition definitions
@[reducible, simp]
def minKAvoidingArraySum_precond (n : Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ k > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Construct a k-avoiding array of length n with minimal sum. -/
def minKAvoidingArray (n : Nat) (k : Nat) : List Nat :=
  let half_k := k / 2
  let first_part := List.range half_k |>.map (· + 1)
  let second_part := List.range (n - first_part.length) |>.map (fun i => k + i)
  first_part ++ second_part

-- Main function definitions
def minKAvoidingArraySum (n : Nat) (k : Nat) (h_precond : minKAvoidingArraySum_precond (n) (k)) : Nat :=
  -- !benchmark @start code
  minKAvoidingArray n k |>.foldl (· + ·) 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- The set of all k-avoiding arrays of length n. -/
def KAvoidingArrays (n : Nat) (k : Nat) : Set (List Nat) :=
  { arr | arr.length = n ∧ DistinctPositiveIntegers arr ∧ IsKAvoiding k arr }

-- Postcondition definitions
@[reducible, simp]
def minKAvoidingArraySum_postcond (n : Nat) (k : Nat) (result: Nat) (h_precond : minKAvoidingArraySum_precond (n) (k)) : Prop :=
  -- !benchmark @start postcond
  ∃ (arr_min : List Nat),
      arr_min ∈ KAvoidingArrays n k ∧
      result = arr_min.foldl (· + ·) 0 ∧
      ∀ (arr : List Nat),
        arr ∈ KAvoidingArrays n k → arr_min.foldl (· + ·) 0 ≤ arr.foldl (· + ·) 0
  -- !benchmark @end postcond


-- Proof content
theorem minKAvoidingArraySum_postcond_satisfied (n: Nat) (k: Nat) (h_precond : minKAvoidingArraySum_precond (n) (k)) :
    minKAvoidingArraySum_postcond (n) (k) (minKAvoidingArraySum (n) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof