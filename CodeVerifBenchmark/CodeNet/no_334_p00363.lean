import Mathlib

namespace no_334_p00363


-- Precondition definitions
@[reducible, simp]
def makeFlag_precond (w : Nat) (h : Nat) (c : Char) : Prop :=
  -- !benchmark @start precond
  -- Width and height must be at least 3 and both must be odd numbers
  w ≥ 3 ∧ h ≥ 3 ∧ w ≤ 21 ∧ h ≤ 21 ∧ w % 2 = 1 ∧ h % 2 = 1 ∧ c.isUpper
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to create a single line of the flag
def makeFlagLine (w : Nat) (c : Char) (row : Nat) (h : Nat) : String :=
  if row = 0 || row = h - 1 then
    -- Top or bottom border
    "+" ++ String.mk (List.replicate (w - 2) '-') ++ "+"
  else if row = h / 2 then
    -- Middle row with the character
    "|" ++ String.mk (List.replicate ((w - 2) / 2) '.') ++ String.singleton c ++ String.mk (List.replicate ((w - 2) / 2) '.') ++ "|"
  else
    -- Regular row with dots
    "|" ++ String.mk (List.replicate (w - 2) '.') ++ "|"

-- Main function definitions
def makeFlag (w : Nat) (h : Nat) (c : Char) (h_precond : makeFlag_precond (w) (h) (c)) : String :=
  -- !benchmark @start code
  -- Generate all lines of the flag
    let lines := List.range h |>.map fun row =>
      makeFlagLine w c row h
    -- Join lines with newlines
    String.intercalate "\n" lines
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Helper function to get the expected character at position (row, col)
def expectedChar (w h : Nat) (c : Char) (row col : Nat) : Char :=
  if row = 0 || row = h - 1 then
    if col = 0 || col = w - 1 then '+' else '-'
  else
    if col = 0 || col = w - 1 then '|'
    else if row = h / 2 ∧ col = w / 2 then c
    else '.'

-- Helper function to build the expected output
def buildExpectedFlag (w h : Nat) (c : Char) : String :=
  let lines := List.range h |>.map fun row =>
    let chars := List.range w |>.map fun col =>
      expectedChar w h c row col
    String.mk chars
  String.intercalate "\n" lines

-- Postcondition definitions
@[reducible, simp]
def makeFlag_postcond (w : Nat) (h : Nat) (c : Char) (result: String) (h_precond : makeFlag_precond (w) (h) (c)) : Prop :=
  -- !benchmark @start postcond
  -- The result should be the flag with h lines separated by newlines
  -- Each line should have exactly w characters
  -- The flag should have the proper border characters and the initial in the center
  result = buildExpectedFlag w h c
  -- !benchmark @end postcond


-- Proof content
theorem makeFlag_postcond_satisfied (w: Nat) (h: Nat) (c: Char) (h_precond : makeFlag_precond (w) (h) (c)) :
    makeFlag_postcond (w) (h) (c) (makeFlag (w) (h) (c) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_334_p00363