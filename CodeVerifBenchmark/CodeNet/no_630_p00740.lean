import Mathlib

-- Precondition definitions
@[reducible, simp]
def nextMayor_precond (n : Nat) (p : Nat) : Prop :=
  -- !benchmark @start precond
  3 ≤ n ∧ n ≤ 50 ∧ 2 ≤ p ∧ p ≤ 50
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to simulate the game
def simulateGameImpl (n : Nat) (p : Nat) : Nat :=
  let rec loop (currentPlayer : Nat) (bowlPebbles : Int) (playerPebbles : Array Nat) (totalSteps : Nat) : Nat :=
    if totalSteps > 1000000 then currentPlayer -- Safety bound
    else
      -- Check if current player has all pebbles (game end condition)
      if playerPebbles[currentPlayer]! == p then currentPlayer
      else
        -- Take or put pebbles
        let (newBowl, newPlayerPebbles) :=
          if bowlPebbles > 0 then
            -- Take one pebble from bowl
            (bowlPebbles - 1, playerPebbles.set! currentPlayer (playerPebbles[currentPlayer]! + 1))
          else
            -- Put all pebbles back in bowl
            (playerPebbles[currentPlayer]!, playerPebbles.set! currentPlayer 0)
        -- Move to next player
        let nextPlayer := (currentPlayer + 1) % n
        loop nextPlayer newBowl newPlayerPebbles (totalSteps + 1)
  termination_by 1000000 - totalSteps
  decreasing_by sorry
  loop 0 p (Array.mkArray n 0) 0

-- Main function definitions
def nextMayor (n : Nat) (p : Nat) (h_precond : nextMayor_precond (n) (p)) : Nat :=
  -- !benchmark @start code
  simulateGameImpl n p
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Simulate the game to determine the winner
def simulateGame (n : Nat) (p : Nat) : Nat :=
  let rec loop (currentPlayer : Nat) (bowlPebbles : Int) (playerPebbles : Array Nat) (totalSteps : Nat) : Nat :=
    if totalSteps > 1000000 then currentPlayer -- Safety bound
    else
      -- Check if current player has all pebbles (game end condition)
      if playerPebbles[currentPlayer]! == p then currentPlayer
      else
        -- Take or put pebbles
        let (newBowl, newPlayerPebbles) :=
          if bowlPebbles > 0 then
            -- Take one pebble from bowl
            (bowlPebbles - 1, playerPebbles.set! currentPlayer (playerPebbles[currentPlayer]! + 1))
          else
            -- Put all pebbles back in bowl
            (playerPebbles[currentPlayer]!, playerPebbles.set! currentPlayer 0)
        -- Move to next player
        let nextPlayer := (currentPlayer + 1) % n
        loop nextPlayer newBowl newPlayerPebbles (totalSteps + 1)
  termination_by 1000000 - totalSteps
  decreasing_by sorry
  loop 0 p (Array.mkArray n 0) 0

-- Postcondition definitions
@[reducible, simp]
def nextMayor_postcond (n : Nat) (p : Nat) (result: Nat) (h_precond : nextMayor_precond (n) (p)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the winner determined by the game simulation
  result = simulateGame n p ∧ result < n
  -- !benchmark @end postcond


-- Proof content
theorem nextMayor_postcond_satisfied (n: Nat) (p: Nat) (h_precond : nextMayor_precond (n) (p)) :
    nextMayor_postcond (n) (p) (nextMayor (n) (p) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof