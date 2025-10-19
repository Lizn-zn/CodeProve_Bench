import Mathlib

-- Precondition auxiliary definitions
def sortedDistinct (l : List Nat) : Prop :=
  l.Sorted (· ≤ ·) ∧ l.Nodup

def sumOfFirstKSkipExisting (nums : List Nat) (k : Nat) : Nat :=
  let numsSorted := nums.eraseDups.mergeSort (· ≤ ·)
  let candidates := List.range (numsSorted.length + k + 1) |>.tail!
  let missing := candidates.filter (!numsSorted.contains ·)
  missing.take k |>.sum

-- Precondition definitions
@[reducible, simp]
def minSum_precond (nums : List Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sort a list -/
def List.sort (l : List Nat) : List Nat :=
  l.mergeSort (· ≤ ·)

/-- Remove duplicates and sort a list -/
def List.dedupSort (l : List Nat) : List Nat :=
  l.eraseDups.sort

/-- Sum of first n natural numbers -/
def sumFirstN (n : Nat) : Nat :=
  n * (n + 1) / 2

/-- Sum of arithmetic sequence from start to start + count - 1 -/
def sumArithSeq (start count : Nat) : Nat :=
  count * (2 * start + count - 1) / 2

-- Main function definitions
def minSum (nums : List Nat) (k : Nat) (h_precond : minSum_precond (nums) (k)) : Nat :=
  -- !benchmark @start code
  let sortedNums := nums.dedupSort
  let targetCount := k

  -- Find the smallest numbers not in sortedNums
  -- We'll iterate through natural numbers and skip those in sortedNums
  -- But for efficiency, we compute directly

  -- The idea is to find how many numbers from 1..m are missing
  -- and pick the first k missing ones

  -- But since nums can be large and k can be up to 10^8,
  -- we need an efficient method.

  -- Let's sort and dedup nums first
  -- Then simulate picking numbers

  -- A better approach:
  -- We can compute the sum directly by identifying the ranges
  -- of missing numbers

  -- Helper: given a sorted list of numbers and a count k,
  -- find the sum of the first k missing positive integers

  -- Let's define a function to compute this

  -- We'll use an efficient approach:
  -- 1. Sort and deduplicate nums
  -- 2. Iterate through the sorted list and count how many numbers
  --    we can take from each gap
  -- 3. Sum the arithmetic sequences

  let rec loop (lst : List Nat) (next : Nat) (remaining : Nat) (acc : Nat) : Nat :=
    if remaining = 0 then
      acc
    else
      match lst with
      | [] =>
          -- No more numbers in nums, just take from next onwards
          acc + sumArithSeq next remaining
      | head :: tail =>
          if next > head then
            -- next is ahead, move to head+1
            loop tail (head + 1) remaining acc
          else if next = head then
            -- next is occupied, move to next+1
            loop tail (next + 1) remaining acc
          else
            -- There's a gap from next to head-1
            let gapSize := head - next
            if gapSize ≥ remaining then
              -- Take only part of the gap
              acc + sumArithSeq next remaining
            else
              -- Take the whole gap
              let gapSum := sumArithSeq next gapSize
              loop tail (head + 1) (remaining - gapSize) (acc + gapSum)
  termination_by lst.length + remaining

  loop sortedNums 1 k 0
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def minSum_postcond (nums : List Nat) (k : Nat) (result: Nat) (h_precond : minSum_precond (nums) (k)) : Prop :=
  -- !benchmark @start postcond
  result = sumOfFirstKSkipExisting nums k
  -- !benchmark @end postcond


-- Proof content
theorem minSum_postcond_satisfied (nums: List Nat) (k: Nat) (h_precond : minSum_precond (nums) (k)) :
    minSum_postcond (nums) (k) (minSum (nums) (k) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof