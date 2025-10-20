import Mathlib

namespace no_1205_leetcode_2410


-- Precondition auxiliary definitions
def IsMatching (players : List Nat) (trainers : List Nat) (matching : List (Nat × Nat)) : Prop :=
  -- Each pair (i, j) in matching satisfies players[i] ≤ trainers[j]
  ∀ p ∈ matching, p.fst < players.length ∧ p.snd < trainers.length ∧ players[p.fst]! ≤ trainers[p.snd]! ∧
  -- All player indices in matching are unique
  (matching.map Prod.fst).Nodup ∧
  -- All trainer indices in matching are unique
  (matching.map Prod.snd).Nodup

-- !benchmark @end precond_aux

-- Precondition definitions
@[reducible, simp]
def max_matchings_precond (players : List Nat) (trainers : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  
  -- !benchmark @end precond
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Sorts a list of natural numbers in ascending order. -/
def sortAsc (l : List Nat) : List Nat :=
  l.mergeSort (· ≤ ·)

/-- Constructs a greedy matching by sorting both lists and pairing greedily. -/
def constructGreedyMatching (sortedPlayers sortedTrainers : List Nat) : List (Nat × Nat) :=
  let rec go (ps ts : List Nat) (acc : List (Nat × Nat)) : List (Nat × Nat) :=
    match ps, ts with
    | [], _ => acc.reverse
    | _, [] => acc.reverse
    | p :: ps', t :: ts' =>
      if p ≤ t then
        go ps' ts' ((p, t) :: acc)
      else
        go ps ts' acc
  go sortedPlayers sortedTrainers []

/-- Counts how many players can be matched to trainers greedily. -/
def countGreedyMatchings (players trainers : List Nat) : Nat :=
  let sortedPlayers := sortAsc players
  let sortedTrainers := sortAsc trainers
  (constructGreedyMatching sortedPlayers sortedTrainers).length

-- Main function definitions
def max_matchings (players : List Nat) (trainers : List Nat) (h_precond : max_matchings_precond (players) (trainers)) : Nat :=
  -- !benchmark @start code
  countGreedyMatchings players trainers
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- !benchmark @end postcond_aux

-- Postcondition definitions
@[reducible, simp]
def max_matchings_postcond (players : List Nat) (trainers : List Nat) (result: Nat) (h_precond : max_matchings_precond (players) (trainers)) : Prop :=
  -- !benchmark @start postcond
  ∃ matching : List (Nat × Nat),
    IsMatching players trainers matching ∧
    result = matching.length ∧
    -- Maximality: no larger matching exists
    ¬∃ matching' : List (Nat × Nat),
      IsMatching players trainers matching' ∧
      matching'.length > matching.length
  
  -- !benchmark @end postcond
  -- !benchmark @end postcond


-- Proof content
theorem max_matchings_postcond_satisfied (players: List Nat) (trainers: List Nat) (h_precond : max_matchings_precond (players) (trainers)) :
    max_matchings_postcond (players) (trainers) (max_matchings (players) (trainers) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1205_leetcode_2410