import Mathlib

-- Precondition definitions
@[reducible, simp]
def solveHardBeans_precond (n : Nat) (beans : List Int) (queries : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  -- N is the number of beans (1 ≤ N ≤ 10^5)
  n ≥ 1 ∧ n ≤ 100000 ∧
  -- beans list has exactly N elements
  beans.length = n ∧
  -- Each bean hardness is within bounds: |a_i| ≤ 10^6
  (∀ i : Fin beans.length, beans[i]!.natAbs ≤ 1000000) ∧
  -- Q (number of queries) is at least 1 and at most 10^5
  queries.length ≥ 1 ∧ queries.length ≤ 100000 ∧
  -- For each query (l, r, D):
  -- 0 ≤ l ≤ r ≤ N-1
  -- 0 ≤ D ≤ 10^6
  (∀ q ∈ queries, q.1 ≤ q.2.1 ∧ q.2.1 < n ∧ q.2.2 ≤ 1000000)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute minimum absolute difference in a range
def computeMinAbsDiff (beans : List Int) (l r : Nat) (D : Nat) : Nat :=
  let beansArray := beans.toArray
  Id.run do
    let mut minDiff := Int.natAbs (beansArray[l]! - D)
    for i in [l:r+1] do
      let diff := Int.natAbs (beansArray[i]! - D)
      minDiff := min minDiff diff
    return minDiff

-- Main function definitions
def solveHardBeans (n : Nat) (beans : List Int) (queries : List (Nat × Nat × Nat)) (h_precond : solveHardBeans_precond (n) (beans) (queries)) : List Nat :=
  -- !benchmark @start code
  -- Process each query and compute the minimum absolute difference
    let beansArray := beans.toArray
    queries.map (fun query =>
      let l := query.1
      let r := query.2.1
      let D := query.2.2
      computeMinAbsDiff beans l r D
    )
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the minimum absolute difference
-- between D and any bean hardness in the range [l, r]
def minAbsDiff (beans : List Int) (l r : Nat) (D : Nat) : Nat :=
  let beansInRange := beans.toArray.toSubarray l (r + 1) |>.toList
  beansInRange.foldl (fun acc bean => min acc (Int.natAbs (bean - D))) (Int.natAbs (beans[l]! - D))

-- Postcondition definitions
@[reducible, simp]
def solveHardBeans_postcond (n : Nat) (beans : List Int) (queries : List (Nat × Nat × Nat)) (result: List Nat) (h_precond : solveHardBeans_precond (n) (beans) (queries)) : Prop :=
  -- !benchmark @start postcond
  -- The result list has the same length as the queries list
  result.length = queries.length ∧
  -- For each query at index i, the result at index i is the minimum absolute difference
  -- between D and any bean hardness in the range [l, r]
  (∀ i : Fin queries.length,
    let query := queries[i]!
    let l := query.1
    let r := query.2.1
    let D := query.2.2
    result[i]! = minAbsDiff beans l r D)
  -- !benchmark @end postcond


-- Proof content
theorem solveHardBeans_postcond_satisfied (n: Nat) (beans: List Int) (queries: List (Nat × Nat × Nat)) (h_precond : solveHardBeans_precond (n) (beans) (queries)) :
    solveHardBeans_postcond (n) (beans) (queries) (solveHardBeans (n) (beans) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof