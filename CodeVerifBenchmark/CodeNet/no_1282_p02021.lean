import Mathlib

namespace no_1282_p02021


-- Precondition definitions
@[reducible, simp]
def maxWorkPerDay_precond (n : Nat) (tasks : List Nat) : Prop :=
  -- !benchmark @start precond
  n > 0 ∧ tasks.length = n ∧ (∀ i, i < tasks.length → tasks[i]! > 0)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute cumulative sums
def computeCumulativeSums (tasks : List Nat) : List Nat :=
  let rec aux (remaining : List Nat) (acc : Nat) (result : List Nat) : List Nat :=
    match remaining with
    | [] => result.reverse
    | x :: xs => aux xs (acc + x) ((acc + x) :: result)
  aux tasks 0 []

-- Helper function to compute max work per day for each day
def computeMaxWorkPerDayList (tasks : List Nat) : List Nat :=
  let cumSums := computeCumulativeSums tasks
  cumSums.mapIdx (fun i sum => sum / (i + 1))

-- Helper function to find minimum in a non-empty list
def listMin (l : List Nat) (h : l.length > 0) : Nat :=
  match l with
  | [] => 0  -- unreachable due to precondition
  | x :: xs => xs.foldl Nat.min x

-- Main function definitions
def maxWorkPerDay (n : Nat) (tasks : List Nat) (h_precond : maxWorkPerDay_precond (n) (tasks)) : Nat :=
  -- !benchmark @start code
  let maxWorkList := computeMaxWorkPerDayList tasks
    have h_nonempty : maxWorkList.length > 0 := by
      simp [computeMaxWorkPerDayList, computeCumulativeSums]
      have : tasks.length > 0 := by
        have := h_precond.2.1
        omega
      sorry
    listMin maxWorkList h_nonempty
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Cumulative sum of tasks up to day i (0-indexed)
def cumulativeSum (tasks : List Nat) (i : Nat) : Nat :=
  (tasks.take (i + 1)).foldl (· + ·) 0

-- Maximum work per day if we finish all work up to day i on day i
def maxWorkOnDay (tasks : List Nat) (i : Nat) : Nat :=
  cumulativeSum tasks i / (i + 1)

-- The result is the minimum of maxWorkOnDay across all days
def isValidMaxWork (tasks : List Nat) (result : Nat) : Prop :=
  (∀ i, i < tasks.length → result ≤ maxWorkOnDay tasks i) ∧
  (∃ i, i < tasks.length ∧ result = maxWorkOnDay tasks i)

-- Postcondition definitions
@[reducible, simp]
def maxWorkPerDay_postcond (n : Nat) (tasks : List Nat) (result: Nat) (h_precond : maxWorkPerDay_precond (n) (tasks)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum number of tasks that can be done per day
    -- such that on every day i, we never run out of work
    -- This is equivalent to finding the minimum of (cumulative_sum[i] / (i+1)) for all i
    isValidMaxWork tasks result
  -- !benchmark @end postcond


-- Proof content
theorem maxWorkPerDay_postcond_satisfied (n: Nat) (tasks: List Nat) (h_precond : maxWorkPerDay_precond (n) (tasks)) :
    maxWorkPerDay_postcond (n) (tasks) (maxWorkPerDay (n) (tasks) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1282_p02021