import Mathlib

-- Precondition auxiliary definitions
def sortedPlayersWithScoreAndAge (scores : List Nat) (ages : List Nat) : List (Nat × Nat) :=
  List.zip scores ages |>.mergeSort (fun a b => a.2 < b.2 ∨ (a.2 = b.2 ∧ a.1 ≤ b.1))

def hasNoConflict (players : List (Nat × Nat)) : Prop :=
  ∀ i j, i < j → j < players.length → players[i]!.1 ≤ players[j]!.1

def isSubsequence (sub seq : List (Nat × Nat)) : Prop :=
  ∃ indices : List Nat,
    List.Sorted (· < ·) indices ∧
    indices.all (fun i => i < seq.length) ∧
    sub = indices.map (fun i => seq[i]!)

def sumScores (players : List (Nat × Nat)) : Nat :=
  players.foldl (fun acc player => acc + player.1) 0

-- Precondition definitions
@[reducible, simp]
def bestTeamScore_precond (scores : List Nat) (ages : List Nat) : Prop :=
  -- !benchmark @start precond
  scores.length = ages.length ∧ scores.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def bestTeamScoreDP (players : List (Nat × Nat)) : Nat :=
  match players with
  | [] => 0
  | _ =>
    let n := players.length
    let dp : Array Nat := Array.mk (List.replicate n 0)
    let dp := dp.set! 0 (players[0]!.1)
    let dp := (List.range n).foldl (fun dp i =>
      let (score_i, _) := players[i]!
      let maxPrev := (List.range i).foldl (fun maxVal j =>
        let (score_j, _) := players[j]!
        if score_j ≤ score_i then
          Nat.max maxVal dp[j]!
        else
          maxVal
      ) 0
      dp.set! i (maxPrev + score_i)
    ) dp
    dp.foldl Nat.max 0

-- Main function definitions
def bestTeamScore (scores : List Nat) (ages : List Nat) (h_precond : bestTeamScore_precond (scores) (ages)) : Nat :=
  -- !benchmark @start code
  let players := sortedPlayersWithScoreAndAge scores ages
  bestTeamScoreDP players
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def bestTeamScore_postcond (scores : List Nat) (ages : List Nat) (result: Nat) (h_precond : bestTeamScore_precond (scores) (ages)) : Prop :=
  -- !benchmark @start postcond
  let players := sortedPlayersWithScoreAndAge scores ages
  let validTeams := { team : List (Nat × Nat) // isSubsequence team players ∧ hasNoConflict team }
  result = ⨆ (team : validTeams), sumScores team.1
  -- !benchmark @end postcond


-- Proof content
theorem bestTeamScore_postcond_satisfied (scores: List Nat) (ages: List Nat) (h_precond : bestTeamScore_precond (scores) (ages)) :
    bestTeamScore_postcond (scores) (ages) (bestTeamScore (scores) (ages) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof