import Mathlib

-- Precondition auxiliary definitions
def playerBounds (n : Nat) (pick : List (Nat × Nat)) : Prop :=
  ∀ p : Nat × Nat, p ∈ pick → p.1 < n

def colorBounds (pick : List (Nat × Nat)) : Prop :=
  ∀ p : Nat × Nat, p ∈ pick → p.2 ≤ 10

-- Precondition definitions
@[reducible, simp]
def countWinningPlayers_precond (n : Nat) (pick : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  n ≥ 2 ∧ n ≤ 10 ∧ pick.length ≤ 100 ∧ pick ≠ [] ∧ playerBounds n pick ∧ colorBounds pick
  -- !benchmark @end precond


-- Code auxiliary definitions
def countPlayerBalls (pick : List (Nat × Nat)) (player : Nat) (color : Nat) : Nat :=
  (pick.filter (fun p : Nat × Nat => p.1 = player ∧ p.2 = color)).length

def playerWins (pick : List (Nat × Nat)) (player : Nat) : Prop :=
  ∃ color : Nat, countPlayerBalls pick player color ≥ player + 1

-- Ensure decidability for playerWins
noncomputable instance (pick : List (Nat × Nat)) (player : Nat) : Decidable (playerWins pick player) :=
  Classical.dec _

-- Main function definitions
noncomputable def countWinningPlayers (n : Nat) (pick : List (Nat × Nat)) (h_precond : countWinningPlayers_precond n pick) : Nat :=
  -- !benchmark @start code
  ((List.range n).filter (fun i : Nat => decide (playerWins pick i))).length
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def countWinningPlayers_postcond (n : Nat) (pick : List (Nat × Nat)) (result: Nat) (h_precond : countWinningPlayers_precond n pick) : Prop :=
  -- !benchmark @start postcond
  result = ((List.range n).filter (fun i : Nat => decide (playerWins pick i))).length
  -- !benchmark @end postcond


-- Proof content
theorem countWinningPlayers_postcond_satisfied (n: Nat) (pick: List (Nat × Nat)) (h_precond : countWinningPlayers_precond n pick) :
    countWinningPlayers_postcond n pick (countWinningPlayers n pick h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof