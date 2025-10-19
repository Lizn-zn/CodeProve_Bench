import Mathlib

-- Precondition definitions
@[reducible, simp]
def maxRewardWithinDeadline_precond (n : Nat) (m : Nat) (jobs : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  jobs.length = n
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to insert into a max heap (represented as sorted list in descending order)
def insertHeap (heap : List Nat) (value : Nat) : List Nat :=
  let rec insert (h : List Nat) : List Nat :=
    match h with
    | [] => [value]
    | x :: xs => if value >= x then value :: x :: xs else x :: insert xs
  insert heap

-- Helper function to pop max from heap
def popHeap (heap : List Nat) : Option (Nat × List Nat) :=
  match heap with
  | [] => none
  | x :: xs => some (x, xs)

-- Group jobs by their delay
def groupJobsByDelay (jobs : List (Nat × Nat)) (m : Nat) : List (List Nat) :=
  let rec go (idx : Nat) (acc : List (List Nat)) : List (List Nat) :=
    if idx >= jobs.length then acc
    else
      let (delay, reward) := jobs[idx]!
      if delay > m then go (idx + 1) acc
      else
        let updated := acc.set delay (reward :: acc[delay]!)
        go (idx + 1) updated
  go 0 (List.replicate (m + 1) [])

-- Process jobs day by day, greedily selecting highest rewards
def processJobs (groupedJobs : List (List Nat)) : Nat :=
  let rec go (day : Nat) (heap : List Nat) (totalReward : Nat) : Nat :=
    if day >= groupedJobs.length then totalReward
    else
      -- Add all jobs available on this day to the heap
      let jobsToday := groupedJobs[day]!
      let newHeap := jobsToday.foldl insertHeap heap
      -- Try to take the best job from the heap
      match popHeap newHeap with
      | none => go (day + 1) newHeap totalReward
      | some (reward, remainingHeap) => go (day + 1) remainingHeap (totalReward + reward)
  go 0 [] 0

-- Main function definitions
def maxRewardWithinDeadline (n : Nat) (m : Nat) (jobs : List (Nat × Nat)) (h_precond : maxRewardWithinDeadline_precond (n) (m) (jobs)) : Nat :=
  -- !benchmark @start code
  let groupedJobs := groupJobsByDelay jobs m
  processJobs groupedJobs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid schedule is a list of job indices (into the jobs list) that we complete
def validSchedule (jobs : List (Nat × Nat)) (m : Nat) (schedule : List Nat) : Prop :=
  -- All indices are valid
  (∀ i ∈ schedule, i < jobs.length) ∧
  -- All indices are unique (no job is done twice)
  schedule.Nodup ∧
  -- Each job completes within the deadline:
  -- If we do job i on day d (0-indexed), we get reward on day d + jobs[i].1
  -- This must be ≤ m (since we have days 0 through m-1 available, and rewards come by day m)
  (∀ idx ∈ List.finRange schedule.length, 
    let jobIdx := schedule[idx]!
    let dayDone := idx  -- 0-indexed day when job is done
    let (delay, _) := jobs[jobIdx]!
    dayDone + delay ≤ m)

def scheduleReward (jobs : List (Nat × Nat)) (schedule : List Nat) : Nat :=
  schedule.foldl (fun acc jobIdx => 
    let (_, reward) := jobs[jobIdx]!
    acc + reward
  ) 0

-- Postcondition definitions
@[reducible, simp]
def maxRewardWithinDeadline_postcond (n : Nat) (m : Nat) (jobs : List (Nat × Nat)) (result: Nat) (h_precond : maxRewardWithinDeadline_precond (n) (m) (jobs)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the maximum reward achievable
  (∃ schedule : List Nat, validSchedule jobs m schedule ∧ result = scheduleReward jobs schedule) ∧
  (∀ schedule : List Nat, validSchedule jobs m schedule → scheduleReward jobs schedule ≤ result)
  -- !benchmark @end postcond


-- Proof content
theorem maxRewardWithinDeadline_postcond_satisfied (n: Nat) (m: Nat) (jobs: List (Nat × Nat)) (h_precond : maxRewardWithinDeadline_precond (n) (m) (jobs)) :
    maxRewardWithinDeadline_postcond (n) (m) (jobs) (maxRewardWithinDeadline (n) (m) (jobs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof