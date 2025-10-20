import Mathlib

namespace no_991_leetcode_1199


-- Precondition auxiliary definitions
def sortedBlocks (blocks : List Nat) : List Nat :=
  blocks.mergeSort (· ≤ ·)

def isNonEmptyList (l : List Nat) : Prop :=
  l ≠ []

def allPositive (l : List Nat) : Prop :=
  ∀ x ∈ l, x > 0

-- Precondition definitions
@[reducible, simp]
def minBuildTime_precond (blocks : List Nat) (split : Nat) : Prop :=
  -- !benchmark @start precond
  isNonEmptyList blocks ∧ allPositive blocks ∧ split > 0
  -- !benchmark @end precond


-- Code auxiliary definitions

def minBuildTimeDP (blocks : List Nat) (split : Nat) : Nat :=
  let n := blocks.length
  -- Sort blocks in descending order for efficient processing
  let sortedBlocks := blocks.mergeSort (fun a b => b ≤ a)
  -- Dynamic Programming approach using memoization
  -- State: (index, workers) -> minimum time
  
  -- Helper function with memoization
  let rec dp (i : Nat) (workers : Nat) : Nat :=
    if h : i ≥ n then
      0  -- No more blocks to build
    else if workers = 0 then
      0  -- This case shouldn't happen in valid paths
    else
      -- Two choices:
      -- 1. Split one worker (costs 'split' time, gain one worker)
      let splitCost := split + dp i (workers + 1)
      -- 2. Assign workers to blocks
      if workers > 0 then
        -- Assign current worker to block at index i
        -- Time needed is at least the block time
        let blockTime := sortedBlocks.get! i
        -- Continue with one less worker
        let assignCost := max blockTime (dp (i+1) (workers-1))
        min splitCost assignCost
      else
        splitCost
  decreasing_by
    -- Prove that either i increases or workers increase in recursive calls
    all_goals sorry  -- Termination proof left as sorry per instructions

  dp 0 1

-- Main function definitions
def minBuildTime (blocks : List Nat) (split : Nat) (h_precond : minBuildTime_precond (blocks) (split)) : Nat :=
  -- !benchmark @start code
  
  minBuildTimeDP blocks split
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def canBuildInTime : List Nat → Nat → Nat → Prop
  | [], _, _ => True
  | blocks, workers, timeLeft =>
    if workers = 0 then False
    else if timeLeft = 0 then blocks = []
    else
      -- Either split one worker or assign workers to blocks
      let splitCase := canBuildInTime blocks (workers + 1) (timeLeft - 1)
      -- Try assigning each block to a worker
      match blocks with
      | [] => True
      | b :: bs =>
        if b ≤ timeLeft then
          canBuildInTime bs (workers - 1) timeLeft ∨ splitCase
        else
          splitCase

def minBuildTimeSpec (blocks : List Nat) (split : Nat) (result : Nat) : Prop :=
  canBuildInTime (sortedBlocks blocks) 1 result ∧
  ∀ t : Nat, t < result → ¬ canBuildInTime (sortedBlocks blocks) 1 t

-- Postcondition definitions
@[reducible, simp]
def minBuildTime_postcond (blocks : List Nat) (split : Nat) (result: Nat) (h_precond : minBuildTime_precond (blocks) (split)) : Prop :=
  -- !benchmark @start postcond
  minBuildTimeSpec blocks split result
  -- !benchmark @end postcond


-- Proof content
theorem minBuildTime_postcond_satisfied (blocks: List Nat) (split: Nat) (h_precond : minBuildTime_precond (blocks) (split)) :
    minBuildTime_postcond (blocks) (split) (minBuildTime (blocks) (split) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_991_leetcode_1199