import Mathlib

-- Precondition auxiliary definitions
/-- The prefix sum of candiesCount up to index `n`. -/
def candiesPrefixSum (candiesCount : List Nat) (n : Nat) : Nat :=
  (candiesCount.take (n + 1)).foldl (· + ·) 0

/-- Check if a query is valid according to the problem constraints. -/
def isValidQuery (candiesCount : List Nat) (favoriteType favoriteDay dailyCap : Nat) : Prop :=
  favoriteType < candiesCount.length ∧
  dailyCap > 0

-- Precondition definitions
@[reducible, simp]
def canEat_precond (candiesCount : List Nat) (queries : List (Nat × Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  candiesCount ≠ [] ∧
  ∀ query : Nat × Nat × Nat, query ∈ queries →
    let (favoriteType, favoriteDay, dailyCap) := query
    isValidQuery candiesCount favoriteType favoriteDay dailyCap
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Compute prefix sums for candiesCount to allow efficient lookup. -/
def candiesPrefixSums (candiesCount : List Nat) : List Nat :=
  let rec go (acc : Nat) (lst : List Nat) : List Nat :=
    match lst with
    | [] => []
    | x :: xs => let newAcc := acc + x; newAcc :: go newAcc xs
  go 0 candiesCount

/-- Get the prefix sum up to index `n` using the precomputed prefix sums. -/
def getCandyPrefixSum (prefixSums : List Nat) (n : Nat) : Nat :=
  if n >= prefixSums.length then
    prefixSums[prefixSums.length - 1]!
  else
    prefixSums[n]!

-- Main function definitions
def canEat (candiesCount : List Nat) (queries : List (Nat × Nat × Nat)) (h_precond : canEat_precond (candiesCount) (queries)) : List Bool :=
  -- !benchmark @start code
  let prefixSums := candiesPrefixSums candiesCount
  queries.map fun q =>
    let (favoriteType, favoriteDay, dailyCap) := q
    let prefixSumPrev := if favoriteType = 0 then 0 else getCandyPrefixSum prefixSums (favoriteType - 1)
    let prefixSumCurr := getCandyPrefixSum prefixSums favoriteType
    (favoriteDay + 1) ≤ prefixSumCurr && (favoriteDay + 1) * dailyCap ≥ prefixSumPrev + 1
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- For a given query, check if it's possible to eat the favorite candy type on the favorite day
without exceeding the daily cap. -/
def canEatOnDay (candiesCount : List Nat) (favoriteType favoriteDay dailyCap : Nat) : Bool :=
  -- Total number of candies up to and including favoriteType - 1
  let prefixSumPrev := if favoriteType = 0 then 0 else candiesPrefixSum candiesCount (favoriteType - 1)
  -- Total number of candies up to and including favoriteType
  let prefixSumCurr := candiesPrefixSum candiesCount favoriteType
  -- Minimum number of days required to reach the favorite type (eating 1 candy per day)
  let minDays := prefixSumPrev
  -- Maximum number of days we can take to reach the favorite type (eating dailyCap candies per day)
  -- We need to eat at least one candy per day, so maxDays is the total candies before favoriteType+1
  let maxDays := prefixSumCurr
  -- The favorite day must be within the range where we can eat the favorite candy
  -- Day d is 0-indexed, so we eat on days 0, 1, ..., d, ..., favoriteDay
  -- To eat on favoriteDay, we must have started eating candies before or on that day
  -- and we must not have finished all candies of favoriteType before favoriteDay
  -- This translates to:
  -- 1. favoriteDay >= minDays (we have eaten enough candies to reach favoriteType)
  -- 2. (favoriteDay + 1) * dailyCap > prefixSumPrev (we haven't eaten all candies before favoriteType)
  -- 3. favoriteDay * dailyCap < prefixSumCurr (we still have some candies of favoriteType left)
  -- Actually, let's think more carefully.
  -- We eat at least 1 candy per day. So by day `favoriteDay`, we have eaten at least `favoriteDay + 1` candies.
  -- We eat at most `dailyCap` candies per day. So by day `favoriteDay`, we have eaten at most `(favoriteDay + 1) * dailyCap` candies.
  -- To eat a candy of `favoriteType` on day `favoriteDay`:
  -- - We must have eaten all candies of type < `favoriteType`. That is, `prefixSumPrev` candies.
  -- - We must not have eaten all candies of type <= `favoriteType`. That is, less than `prefixSumCurr` candies.
  -- So we need:
  -- 1. By day `favoriteDay`, we have eaten at least `prefixSumPrev + 1` candies.
  --    This means `favoriteDay + 1 >= prefixSumPrev + 1`, or `favoriteDay >= prefixSumPrev`.
  -- 2. By day `favoriteDay`, we have eaten less than `prefixSumCurr` candies.
  --    This means `(favoriteDay + 1) * dailyCap < prefixSumCurr`.
  -- Let's double check with the examples.
  -- Example 1: candiesCount = [7,4,5,3,8], queries = [[0,2,2],...]
  -- For query [0,2,2]:
  -- prefixSumPrev = 0, prefixSumCurr = 7
  -- favoriteDay=2, dailyCap=2
  -- minDays = 0
  -- maxDays = 7
  -- Conditions:
  -- 1. favoriteDay >= prefixSumPrev => 2 >= 0 (True)
  -- 2. (favoriteDay + 1) * dailyCap > prefixSumPrev => 3 * 2 = 6 > 0 (True)
  -- 3. favoriteDay * dailyCap < prefixSumCurr => 2 * 2 = 4 < 7 (True)
  -- Wait, condition 3 is not right. If we eat 4 candies by day 2, we still eat type 0.
  -- Let's re-read the problem.
  -- "Construct a boolean array answer such that ... answer[i] is true if you can eat a candy of type favoriteTypei on day favoriteDayi"
  -- This means on that specific day, we eat a candy of that type.
  -- So, by the end of day `favoriteDay`, we must have eaten at least `prefixSumPrev + 1` candies.
  -- And we must have not eaten all `prefixSumCurr` candies yet.
  -- Which means:
  -- 1. Up to day `favoriteDay` (inclusive), we eat at least `prefixSumPrev + 1` => `(favoriteDay + 1) * 1 >= prefixSumPrev + 1`
  --    Simplifies to `favoriteDay + 1 >= prefixSumPrev + 1` => `favoriteDay >= prefixSumPrev`. 
  -- 2. Up to day `favoriteDay` (inclusive), we eat at most `(favoriteDay + 1) * dailyCap` candies.
  --    We must not have finished all `prefixSumCurr` candies, so `(favoriteDay + 1) * dailyCap < prefixSumCurr` is not correct.
  --    We must have eaten less than `prefixSumCurr` candies, so `(favoriteDay + 1) * dailyCap <= prefixSumCurr - 1`.
  --    But that's also not right, because we could eat exactly `prefixSumCurr - 1` and then one of type `favoriteType`.
  --    The condition is that we can eat a candy of `favoriteType` ON day `favoriteDay`.
  --    This means there exists a way to eat candies such that on day `favoriteDay`, we eat one of type `favoriteType`.
  --    For this to be possible:
  --    - We must have eaten all candies of type < `favoriteType`. That's `prefixSumPrev` candies.
  --    - We must not have eaten ALL candies of type <= `favoriteType`. That's `prefixSumCurr` candies.
  --    - We eat at least 1 candy per day. So by day `favoriteDay`, we eat at least `favoriteDay + 1` candies.
  --    - We eat at most `dailyCap` candies per day. So by day `favoriteDay`, we eat at most `(favoriteDay + 1) * dailyCap` candies.
  --    For the possibility to exist:
  --    1. It must be possible to eat `prefixSumPrev` candies by day `favoriteDay`. 
  --       This means `favoriteDay + 1 >= prefixSumPrev` (if eating 1 per day) is a necessary condition.
  --       But we might eat more per day. The actual constraint is that we can eat at least `prefixSumPrev` in `favoriteDay + 1` days.
  --       If we eat `dailyCap` per day, we eat `dailyCap * (favoriteDay + 1)` in total.
  --       We need `dailyCap * (favoriteDay + 1) >= prefixSumPrev`. This is not right either.
  --       The constraint is that there EXISTS a way.
  --       The maximum number of candies we can eat in `favoriteDay + 1` days is `(favoriteDay + 1) * dailyCap`.
  --       The minimum is `favoriteDay + 1`.
  --       To eat all `prefixSumPrev` candies of previous types by day `favoriteDay`, we need to be able to eat at least that many.
  --       So, `favoriteDay + 1 >= prefixSumPrev` is necessary. But not sufficient if `dailyCap` is small.
  --       Actually, no. We can eat them faster. The minimum number of days to eat `prefixSumPrev` candies is `⌈prefixSumPrev / dailyCap⌉`.
  --       But that's complicated. Let's think differently.
  --       To be able to eat a candy of `favoriteType` on day `favoriteDay`:
  --       - We must finish eating all candies of type < `favoriteType`. This takes at least `prefixSumPrev` candies.
  --         If we eat 1 per day, it takes `prefixSumPrev` days (0 to prefixSumPrev - 1).
  --         If we eat `dailyCap` per day, it takes `⌈prefixSumPrev / dailyCap⌉` days.
  --         So, we must finish by day `favoriteDay`. That means `⌈prefixSumPrev / dailyCap⌉ <= favoriteDay`.
  --         But that's not right either, because we can eat some of type `favoriteType` before `favoriteDay`.
  --       Let's think of it as a range.
  --       By day `favoriteDay`, we eat between `favoriteDay + 1` and `(favoriteDay + 1) * dailyCap` candies.
  --       To eat a candy of `favoriteType` on that day, the total number of candies eaten by then must be
  --       between `prefixSumPrev + 1` and `prefixSumCurr` inclusive.
  --       So, we need:
  --       `favoriteDay + 1 <= prefixSumCurr` and `(favoriteDay + 1) * dailyCap >= prefixSumPrev + 1`.
  --       Let's check with example 1.
  --       candiesCount = [7,4,5,3,8], query = [0,2,2]
  --       favoriteType=0, favoriteDay=2, dailyCap=2
  --       prefixSumPrev = 0, prefixSumCurr = 7
  --       favoriteDay + 1 = 3
  --       (favoriteDay + 1) * dailyCap = 6
  --       Conditions:
  --       1. favoriteDay + 1 <= prefixSumCurr => 3 <= 7 (True)
  --       2. (favoriteDay + 1) * dailyCap >= prefixSumPrev + 1 => 6 >= 1 (True)
  --       Result: True. Correct.
  --       query = [4,2,4]
  --       favoriteType=4, favoriteDay=2, dailyCap=4
  --       prefixSumPrev = 7+4+5+3 = 19, prefixSumCurr = 19+8 = 27
  --       favoriteDay + 1 = 3
  --       (favoriteDay + 1) * dailyCap = 12
  --       Conditions:
  --       1. 3 <= 27 (True)
  --       2. 12 >= 20 (False)
  --       Result: False. Correct.
  --       This looks right.
  --/
  (favoriteDay + 1) ≤ prefixSumCurr ∧
  (favoriteDay + 1) * dailyCap ≥ prefixSumPrev + 1

-- Postcondition definitions
@[reducible, simp]
def canEat_postcond (candiesCount : List Nat) (queries : List (Nat × Nat × Nat)) (result: List Bool) (h_precond : canEat_precond (candiesCount) (queries)) : Prop :=
  -- !benchmark @start postcond
  result.length = queries.length ∧
  ∀ i : Nat, i < queries.length →
    let q := queries[i]!
    let (favoriteType, favoriteDay, dailyCap) := q
    result[i]! = canEatOnDay candiesCount favoriteType favoriteDay dailyCap
  -- !benchmark @end postcond


-- Proof content
theorem canEat_postcond_satisfied (candiesCount: List Nat) (queries: List (Nat × Nat × Nat)) (h_precond : canEat_precond (candiesCount) (queries)) :
    canEat_postcond (candiesCount) (queries) (canEat (candiesCount) (queries) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

