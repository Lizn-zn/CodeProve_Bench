import Mathlib

-- Precondition auxiliary definitions
def is_valid_element (n : Nat) : Prop :=
  n = 1 ∨ n = 2 ∨ n = 3

def all_elements_valid (l : List Nat) : Prop :=
  ∀ x ∈ l, is_valid_element x

-- Precondition definitions
@[reducible, simp]
def min_operations_to_non_decreasing_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  nums.length > 0 ∧ all_elements_valid nums
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the length of the longest non-decreasing subsequence
-- This is equivalent to the classic "Longest Increasing Subsequence" problem, but for non-decreasing sequences

def longest_non_decreasing_subsequence (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | x :: xs =>
    -- For each element, we track the length of the longest non-decreasing subsequence ending at that element
    -- We use a dynamic programming approach with a list of lengths
    let rec compute_dp (lst : List Nat) (dp : List Nat) : List Nat :=
      match lst with
      | [] => dp
      | y :: ys =>
        -- For each element y, find the maximum length in dp such that the corresponding element <= y
        let max_len := 
          (List.zip dp lst).foldl (fun max_val (pair : Nat × Nat) =>
            let len := pair.1
            let elem := pair.2
            if elem <= y ∧ len > max_val then len else max_val
          ) 0
        let new_dp := dp ++ [max_len + 1]
        compute_dp ys new_dp
    
    let initial_dp := [1]  -- The first element forms a subsequence of length 1
    let final_dp := compute_dp xs initial_dp
    final_dp.foldl Nat.max 0  -- Return the maximum value in the dp list


-- Main function definitions
def min_operations_to_non_decreasing (nums : List Nat) (h_precond : min_operations_to_non_decreasing_precond nums) : Nat :=
  -- !benchmark @start code
  -- The minimum number of operations is the total length minus the length of the longest non-decreasing subsequence
  nums.length - longest_non_decreasing_subsequence nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define the cost of removing elements to make the list non-decreasing
-- This uses a dynamic programming approach to compute the minimal number of deletions

def count_non_decreasing (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | [_] => 1
  | x :: xs =>
    let rec helper (prev : Nat) (lst : List Nat) (acc : Nat) : Nat :=
      match lst with
      | [] => acc
      | y :: ys =>
        if y >= prev then
          helper y ys (acc + 1)
        else
          helper prev ys acc
    helper x xs 1

def min_operations_dp (l : List Nat) : Nat :=
  l.length - count_non_decreasing l

-- Postcondition definitions
@[reducible, simp]
def min_operations_to_non_decreasing_postcond (nums : List Nat) (result: Nat) (h_precond : min_operations_to_non_decreasing_precond nums) : Prop :=
  -- !benchmark @start postcond
  result = min_operations_dp nums
  -- !benchmark @end postcond


-- Proof content
theorem min_operations_to_non_decreasing_postcond_satisfied (nums: List Nat) (h_precond : min_operations_to_non_decreasing_precond nums) :
    min_operations_to_non_decreasing_postcond (nums) (min_operations_to_non_decreasing (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof