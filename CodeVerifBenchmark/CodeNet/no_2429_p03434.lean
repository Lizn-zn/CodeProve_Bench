import Mathlib

namespace no_2429_p03434


-- Precondition definitions
@[reducible, simp]
def aliceBobCardGame_precond (cards : List Nat) : Prop :=
  -- !benchmark @start precond
  cards.length ≥ 1 ∧ cards.length ≤ 100 ∧ ∀ x ∈ cards, 1 ≤ x ∧ x ≤ 100
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def aliceBobCardGame (cards : List Nat) (h_precond : aliceBobCardGame_precond (cards)) : Int :=
  -- !benchmark @start code
  let sortedCards := cards.toArray.qsort (· > ·) |>.toList
    let rec playGame (remaining : List Nat) (isAliceTurn : Bool) (aliceScore : Nat) (bobScore : Nat) : Int :=
      match remaining with
      | [] => (aliceScore : Int) - (bobScore : Int)
      | x :: xs =>
        if isAliceTurn then
          playGame xs false (aliceScore + x) bobScore
        else
          playGame xs true aliceScore (bobScore + x)
    playGame sortedCards true 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to simulate the optimal game play
def optimalGamePlay (cards : List Nat) : Int :=
  let sortedCards := cards.toArray.qsort (· > ·) |>.toList
  let rec playGame (remaining : List Nat) (isAliceTurn : Bool) (aliceScore : Nat) (bobScore : Nat) : Int :=
    match remaining with
    | [] => (aliceScore : Int) - (bobScore : Int)
    | x :: xs =>
      if isAliceTurn then
        playGame xs false (aliceScore + x) bobScore
      else
        playGame xs true aliceScore (bobScore + x)
  playGame sortedCards true 0 0

-- Postcondition definitions
@[reducible, simp]
def aliceBobCardGame_postcond (cards : List Nat) (result: Int) (h_precond : aliceBobCardGame_precond (cards)) : Prop :=
  -- !benchmark @start postcond
  result = optimalGamePlay cards
  -- !benchmark @end postcond


-- Proof content
theorem aliceBobCardGame_postcond_satisfied (cards: List Nat) (h_precond : aliceBobCardGame_precond (cards)) :
    aliceBobCardGame_postcond (cards) (aliceBobCardGame (cards) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2429_p03434