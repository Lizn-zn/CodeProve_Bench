import Mathlib

-- Precondition definitions
@[reducible, simp]
def cupGame_precond (swaps : List (String × String)) : Prop :=
  -- !benchmark @start precond
  -- Each swap consists of two valid cup positions (A, B, or C)
    swaps.all (fun (x, y) => 
      (x = "A" ∨ x = "B" ∨ x = "C") ∧ 
      (y = "A" ∨ y = "B" ∨ y = "C"))
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to apply a single swap to the current ball position
def applySwap (pos : String) (swap : String × String) : String :=
  let (x, y) := swap
  if pos = x then y
  else if pos = y then x
  else pos

-- Helper function to apply all swaps starting from position A
def applySwaps (swaps : List (String × String)) : String :=
  swaps.foldl applySwap "A"

-- Main function definitions
def cupGame (swaps : List (String × String)) (h_precond : cupGame_precond (swaps)) : String :=
  -- !benchmark @start code
  applySwaps swaps
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (Moved to code auxiliary definitions section above)

-- Postcondition definitions
@[reducible, simp]
def cupGame_postcond (swaps : List (String × String)) (result: String) (h_precond : cupGame_precond (swaps)) : Prop :=
  -- !benchmark @start postcond
  -- The result is the final position of the ball after applying all swaps
    -- starting from position A
    result = applySwaps swaps ∧
    -- The result must be a valid cup position
    (result = "A" ∨ result = "B" ∨ result = "C")
  -- !benchmark @end postcond


-- Proof content
theorem cupGame_postcond_satisfied (swaps: List (String × String)) (h_precond : cupGame_precond (swaps)) :
    cupGame_postcond (swaps) (cupGame (swaps) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof