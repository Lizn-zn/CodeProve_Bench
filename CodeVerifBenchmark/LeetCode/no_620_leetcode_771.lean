import Mathlib

namespace no_620_leetcode_771


-- Precondition auxiliary definitions
def isJewel (jewels : String) (c : Char) : Bool :=
  c ∈ jewels.data

-- Precondition definitions
@[reducible, simp]
def numJewelsInStones_precond (jewels : String) (stones : String) : Prop :=
  -- !benchmark @start precond
  1 ≤ jewels.length ∧ jewels.length ≤ 50 ∧
  1 ≤ stones.length ∧ stones.length ≤ 50 ∧
  ∀ c ∈ jewels.data, c.val < 128 ∧ c.isAlpha ∧
  ∀ i j : String.Pos, i < jewels.endPos → j < jewels.endPos → i ≠ j → jewels.get i ≠ jewels.get j
  -- !benchmark @end precond


-- Code auxiliary definitions
def countJewels (jewels : String) (stones : String) : Nat :=
  stones.data.foldl (fun acc c => if c ∈ jewels.data then acc + 1 else acc) 0

-- Main function definitions
def numJewelsInStones (jewels : String) (stones : String) (h_precond : numJewelsInStones_precond (jewels) (stones)) : Nat :=
  -- !benchmark @start code
  countJewels jewels stones
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def numJewelsInStones_postcond (jewels : String) (stones : String) (result: Nat) (h_precond : numJewelsInStones_precond (jewels) (stones)) : Prop :=
  -- !benchmark @start postcond
  result = (stones.data.filter (fun c => isJewel jewels c)).length
  -- !benchmark @end postcond


-- Proof content
theorem numJewelsInStones_postcond_satisfied (jewels: String) (stones: String) (h_precond : numJewelsInStones_precond (jewels) (stones)) :
    numJewelsInStones_postcond (jewels) (stones) (numJewelsInStones (jewels) (stones) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_620_leetcode_771