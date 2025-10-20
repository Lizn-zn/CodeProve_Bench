import Mathlib

namespace no_2626_p03658


-- Precondition definitions
@[reducible, simp]
def maxSnakeToyLength_precond (n : Nat) (k : Nat) (sticks : List Nat) : Prop :=
  -- !benchmark @start precond
  -- n and k are positive, k ≤ n, and the sticks list has exactly n elements
  n ≥ 1 ∧ k ≥ 1 ∧ k ≤ n ∧ sticks.length = n
  -- !benchmark @end precond


-- Main function definitions
def maxSnakeToyLength (n : Nat) (k : Nat) (sticks : List Nat) (h_precond : maxSnakeToyLength_precond (n) (k) (sticks)) : Nat :=
  -- !benchmark @start code
  -- Sort the sticks in descending order and take the sum of the first k elements
  (sticks.mergeSort (· ≥ ·)).take k |>.sum
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to get the k largest elements from a list
def kLargest (lst : List Nat) (k : Nat) : List Nat :=
  (lst.mergeSort (· ≥ ·)).take k

-- Helper function to check if a value is the sum of k elements from the list
def isSumOfKElements (lst : List Nat) (k : Nat) (sum : Nat) : Prop :=
  ∃ (selected : List Nat), selected.length = k ∧ 
    (∀ x, x ∈ selected → x ∈ lst) ∧
    selected.sum = sum

-- Postcondition definitions
@[reducible, simp]
def maxSnakeToyLength_postcond (n : Nat) (k : Nat) (sticks : List Nat) (result: Nat) (h_precond : maxSnakeToyLength_precond (n) (k) (sticks)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the sum of the k largest sticks
  result = (kLargest sticks k).sum ∧
    -- The result is achievable by selecting k sticks
    isSumOfKElements sticks k result ∧
    -- The result is maximal: no other selection of k sticks gives a larger sum
    (∀ (selected : List Nat), selected.length = k → 
      (∀ x, x ∈ selected → x ∈ sticks) → 
      selected.sum ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxSnakeToyLength_postcond_satisfied (n: Nat) (k: Nat) (sticks: List Nat) (h_precond : maxSnakeToyLength_precond (n) (k) (sticks)) :
    maxSnakeToyLength_postcond (n) (k) (sticks) (maxSnakeToyLength (n) (k) (sticks) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2626_p03658