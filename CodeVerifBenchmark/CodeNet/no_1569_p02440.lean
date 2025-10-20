import Mathlib

namespace no_1569_p02440


-- Precondition definitions
@[reducible, simp]
def processQueries_precond (nums : Array Int) (queries : Array (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  nums.size > 0 ∧
    ∀ i : Fin queries.size,
      let (op, b, e) := queries[i]
      -- Operation is either 0 (min) or 1 (max)
      (op = 0 ∨ op = 1) ∧
      -- Valid range: 0 ≤ b < e ≤ n
      b < e ∧ e ≤ nums.size
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute minimum in a range using array slicing
def arrayMinInRange (nums : Array Int) (b e : Nat) : Int :=
  Id.run do
    let mut minVal := nums[b]!
    for i in [b:e] do
      if nums[i]! < minVal then
        minVal := nums[i]!
    return minVal

-- Helper function to compute maximum in a range using array slicing
def arrayMaxInRange (nums : Array Int) (b e : Nat) : Int :=
  Id.run do
    let mut maxVal := nums[b]!
    for i in [b:e] do
      if nums[i]! > maxVal then
        maxVal := nums[i]!
    return maxVal

-- Main function definitions
def processQueries (nums : Array Int) (queries : Array (Nat × Nat × Nat)) (h_precond : processQueries_precond (nums) (queries)) : Array Int :=
  -- !benchmark @start code
  Id.run do
    let mut result := Array.mkEmpty queries.size
    for i in [0:queries.size] do
      let (op, b, e) := queries[i]!
      if op = 0 then
        -- Min operation
        result := result.push (arrayMinInRange nums b e)
      else
        -- Max operation
        result := result.push (arrayMaxInRange nums b e)
    return result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute minimum in a range
def minInRange (nums : Array Int) (b e : Nat) : Int :=
  let slice := nums.toList.drop b |>.take (e - b)
  slice.foldl min (slice.head!)

-- Helper function to compute maximum in a range
def maxInRange (nums : Array Int) (b e : Nat) : Int :=
  let slice := nums.toList.drop b |>.take (e - b)
  slice.foldl max (slice.head!)

-- Postcondition definitions
@[reducible, simp]
def processQueries_postcond (nums : Array Int) (queries : Array (Nat × Nat × Nat)) (result: Array Int) (h_precond : processQueries_precond (nums) (queries)) : Prop :=
  -- !benchmark @start postcond
  -- Result has the same length as queries
  result.size = queries.size ∧
    -- Each result corresponds to the correct query result
    ∀ i : Fin queries.size,
      let (op, b, e) := queries[i]
      if op = 0 then
        -- For min operation, result is the minimum in range [b, e)
        result[i]! = minInRange nums b e
      else
        -- For max operation, result is the maximum in range [b, e)
        result[i]! = maxInRange nums b e
  -- !benchmark @end postcond


-- Proof content
theorem processQueries_postcond_satisfied (nums: Array Int) (queries: Array (Nat × Nat × Nat)) (h_precond : processQueries_precond (nums) (queries)) :
    processQueries_postcond (nums) (queries) (processQueries (nums) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1569_p02440