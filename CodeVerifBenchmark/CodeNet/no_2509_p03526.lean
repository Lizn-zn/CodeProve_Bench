import Mathlib

namespace no_2509_p03526


-- Precondition definitions
@[reducible, simp]
def maxParticipantsAddingZabuton_precond (n : Nat) (participants : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  participants.length = n
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Sort participants by h + p
def sortBySum (participants : List (Nat × Nat)) : List (Nat × Nat) :=
  participants.insertionSort (fun a b => a.1 + a.2 ≤ b.1 + b.2)

-- DP to find maximum participants
-- dp[j] represents the minimum stack height to achieve j participants
def computeDP (sorted : List (Nat × Nat)) (n : Nat) : Array Nat :=
  let init := Array.mkArray (n + 1) (10^18)  -- Use large number as infinity
  let init := init.set! 0 0
  sorted.foldl (fun dp (h, p) =>
    let rec updateDP (j : Nat) (dp : Array Nat) : Array Nat :=
      if j == 0 then dp
      else
        let prev := updateDP (j - 1) dp
        if prev[j - 1]! ≤ h then
          prev.set! j (min prev[j]! (prev[j - 1]! + p))
        else
          prev
    termination_by j
    decreasing_by sorry
    updateDP n dp
  ) init

-- Find the maximum j where dp[j] is not infinity
def findMaxParticipants (dp : Array Nat) (n : Nat) : Nat :=
  let rec find (j : Nat) : Nat :=
    if j == 0 then 0
    else if dp[j]! < 10^18 then j
    else find (j - 1)
  termination_by j
  decreasing_by sorry
  find n

-- Main function definitions
def maxParticipantsAddingZabuton (n : Nat) (participants : List (Nat × Nat)) (h_precond : maxParticipantsAddingZabuton_precond (n) (participants)) : Nat :=
  -- !benchmark @start code
  let sorted := sortBySum participants
    let dp := computeDP sorted n
    findMaxParticipants dp n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to check if a participant can add zabuton given current stack height
def canAdd (participant : Nat × Nat) (stackHeight : Nat) : Bool :=
  participant.1 >= stackHeight

-- Helper function to compute the stack height after a sequence of participants
def stackHeightAfter (participants : List (Nat × Nat)) : Nat :=
  participants.foldl (fun acc p => acc + p.2) 0

-- Helper function to count how many participants successfully add zabuton in a given order
def countSuccessful (order : List (Nat × Nat)) : Nat :=
  let (count, _) := order.foldl (fun (acc : Nat × Nat) p =>
    let (cnt, height) := acc
    if p.1 >= height then (cnt + 1, height + p.2) else (cnt, height)
  ) (0, 0)
  count

-- Helper function to check if there exists an ordering achieving k participants
def existsOrderingWithCount (participants : List (Nat × Nat)) (k : Nat) : Prop :=
  ∃ (perm : List (Nat × Nat)), perm.Perm participants ∧ countSuccessful perm = k

-- Postcondition definitions
@[reducible, simp]
def maxParticipantsAddingZabuton_postcond (n : Nat) (participants : List (Nat × Nat)) (result: Nat) (h_precond : maxParticipantsAddingZabuton_precond (n) (participants)) : Prop :=
  -- !benchmark @start postcond
  -- The result is achievable: there exists some ordering where exactly `result` participants can add zabuton
  existsOrderingWithCount participants result ∧
  -- The result is optimal: no ordering allows more than `result` participants to add zabuton
  ∀ (perm : List (Nat × Nat)), perm.Perm participants → countSuccessful perm ≤ result
  -- !benchmark @end postcond


-- Proof content
theorem maxParticipantsAddingZabuton_postcond_satisfied (n: Nat) (participants: List (Nat × Nat)) (h_precond : maxParticipantsAddingZabuton_precond (n) (participants)) :
    maxParticipantsAddingZabuton_postcond (n) (participants) (maxParticipantsAddingZabuton (n) (participants) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2509_p03526