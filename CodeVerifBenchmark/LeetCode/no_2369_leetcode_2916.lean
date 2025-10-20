import Mathlib

namespace no_2369_leetcode_2916


-- Precondition auxiliary definitions
def subarrayDistinctCount (nums : List Nat) (i j : Nat) : Nat :=
  if h : i ≤ j ∧ j < nums.length then
    let subarray := List.take (j - i + 1) (List.drop i nums)
    subarray.toFinset.card
  else
    0

def sumOfSquaresOfSubarrayDistinctCounts (nums : List Nat) : Nat :=
  let n := nums.length
  let indices := List.range n
  let pairs := indices.flatMap fun i => (List.range (n - i)).map fun di => (i, i + di)
  let counts := pairs.map fun (i, j) => subarrayDistinctCount nums i j
  (counts.map (fun c => c * c)).sum

-- Precondition definitions
@[reducible, simp]
def sumOfSquaresOfDistinctCounts_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Efficiently calculates the sum of squares of distinct counts of all subarrays. -/
def sumOfSquaresOfDistinctCountsImpl (nums : List Nat) : Nat :=
  let n := nums.length
  let modVal := 1000000007
  -- dp[i] will store the sum of squares of distinct counts for subarrays ending at index i
  -- We'll compute this iteratively
  let rec loop (i : Nat) (acc : Nat) (lastPos : List (Nat × Nat)) (prevSum : Nat) (prevSqSum : Nat) : Nat :=
    if h : i < n then
      let num := nums.get ⟨i, by omega⟩
      let lastIdx := match lastPos.find? (·.1 == num) with
        | some (_, idx) => idx
        | none => 0
      let contribution := (i + 1 - lastIdx) % modVal
      let newSum := (prevSum + contribution) % modVal
      let delta := (newSum + prevSum) % modVal -- 2 * prevSum, but we need to be careful about overflow
      let newSqSum := (prevSqSum + contribution * delta + contribution) % modVal
      let newLastPos := (lastPos.filter (·.1 ≠ num)).cons (num, i + 1)
      loop (i + 1) ((acc + newSqSum) % modVal) newLastPos newSum newSqSum
    else
      acc
  termination_by nums.length - i
  loop 0 0 [] 0 0

-- Main function definitions
def sumOfSquaresOfDistinctCounts (nums : List Nat) (h_precond : sumOfSquaresOfDistinctCounts_precond (nums)) : Nat :=
  -- !benchmark @start code
  sumOfSquaresOfDistinctCountsImpl nums
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def sumOfSquaresOfDistinctCounts_postcond (nums : List Nat) (result: Nat) (h_precond : sumOfSquaresOfDistinctCounts_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = sumOfSquaresOfSubarrayDistinctCounts nums % (10^9 + 7)
  -- !benchmark @end postcond


-- Proof content
theorem sumOfSquaresOfDistinctCounts_postcond_satisfied (nums: List Nat) (h_precond : sumOfSquaresOfDistinctCounts_precond (nums)) :
    sumOfSquaresOfDistinctCounts_postcond (nums) (sumOfSquaresOfDistinctCounts (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2369_leetcode_2916