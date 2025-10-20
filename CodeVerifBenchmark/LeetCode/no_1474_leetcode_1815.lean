import Mathlib

namespace no_1474_leetcode_1815


-- Precondition auxiliary definitions
def sumModBatch (batchSize : Nat) (groups : List Nat) : Nat :=
  (groups.foldl (fun acc group => acc + group % batchSize) 0) % batchSize

def countNonZeroGroupsModBatch (batchSize : Nat) (groups : List Nat) : Nat :=
  (groups.filter (fun group => group % batchSize ≠ 0)).length

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def maxHappyGroups_precond (batchSize : Nat) (groups : List Nat) : Prop :=
  -- !benchmark @start precond
  batchSize > 0 ∧ batchSize ≤ 9 ∧ groups.length > 0 ∧ groups.length ≤ 30 ∧ ∀ g ∈ groups, g > 0 ∧ g ≤ 10^9
  -- !benchmark @end precond
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Computes the maximum number of happy groups by trying all permutations. -/
def maxHappyGroups_computeMax (batchSize : Nat) (groups : List Nat) : Nat :=
  let perms := List.permutations groups
  let scores := perms.map (fun p =>
    let rec loop (arr : List Nat) (remaining : Nat) (happy : Nat) : Nat :=
      match arr with
      | [] => happy
      | h :: t =>
        let groupMod := h % batchSize
        let newRemaining := (remaining + groupMod) % batchSize
        let newHappy := if remaining = 0 then happy + 1 else happy
        loop t newRemaining newHappy
    loop p 0 0
  )
  match List.maximum scores with
  | some m => m
  | none => 0


-- Main function definitions
def maxHappyGroups (batchSize : Nat) (groups : List Nat) (h_precond : maxHappyGroups_precond (batchSize) (groups)) : Nat :=
  -- !benchmark @start code
  maxHappyGroups_computeMax batchSize groups
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to compute the theoretical upper bound on happy groups
def maxHappyGroups_upperBound (batchSize : Nat) (groups : List Nat) : Nat :=
  let totalRemainder := sumModBatch batchSize groups
  let nonZeroCount := countNonZeroGroupsModBatch batchSize groups
  -- We can make at most one additional group happy if there's leftover donuts
  if totalRemainder = 0 then
    nonZeroCount + 1
  else
    nonZeroCount

-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def maxHappyGroups_postcond (batchSize : Nat) (groups : List Nat) (result: Nat) (h_precond : maxHappyGroups_precond (batchSize) (groups)) : Prop :=
  -- !benchmark @start postcond
  let upperBound := maxHappyGroups_upperBound batchSize groups
  result ≥ 1 ∧ result ≤ upperBound ∧
  ∃ arrangement : List Nat,
    arrangement.Perm groups ∧
    let rec countHappyGroups (arr : List Nat) (remainingDonuts : Nat) (happyCount : Nat) : Nat :=
      match arr with
      | [] => happyCount
      | group :: rest =>
        let groupSize := group % batchSize
        let newRemainingDonuts := (remainingDonuts + groupSize) % batchSize
        let newHappyCount := if remainingDonuts = 0 then happyCount + 1 else happyCount
        countHappyGroups rest newRemainingDonuts newHappyCount
    countHappyGroups arrangement 0 0 = result
  -- !benchmark @end postcond
  -- !benchmark @end postcond


-- Proof content
theorem maxHappyGroups_postcond_satisfied (batchSize: Nat) (groups: List Nat) (h_precond : maxHappyGroups_precond (batchSize) (groups)) :
    maxHappyGroups_postcond (batchSize) (groups) (maxHappyGroups (batchSize) (groups) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1474_leetcode_1815