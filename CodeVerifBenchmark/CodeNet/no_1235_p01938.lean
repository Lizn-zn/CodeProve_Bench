import Mathlib

namespace no_1235_p01938


-- Precondition definitions
@[reducible, simp]
def countASteps_precond (s : String) : Prop :=
  -- !benchmark @start precond
  -- The input string must consist only of uppercase English letters (A-Z)
  s.all (fun c => c.isUpper && c.isAlpha)
  -- !benchmark @end precond


-- Helper function to convert a character to its position (A=0, B=1, ..., Z=25)
def charToPos (c : Char) : Nat :=
  c.toNat - 'A'.toNat

-- Helper function to count the number of times we step on 'A'
-- when moving from position `prev` to position `curr`
def countStepsOnA (prev : Nat) (curr : Nat) : Nat :=
  if curr ≤ prev then 1 else 0

-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def countASteps (s : String) (h_precond : countASteps_precond (s)) : Nat :=
  -- !benchmark @start code
  let chars := s.toList
  let rec loop (chars : List Char) (currentPos : Nat) (acc : Nat) : Nat :=
    match chars with
    | [] => acc
    | c :: cs =>
      let targetPos := charToPos c
      let stepsOnA := countStepsOnA currentPos targetPos
      loop cs targetPos (acc + stepsOnA)
  loop chars 0 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Recursive function to compute the total count
def computeCount (chars : List Char) (currentPos : Nat) (acc : Nat) : Nat :=
  match chars with
  | [] => acc
  | c :: cs =>
    let targetPos := charToPos c
    let stepsOnA := countStepsOnA currentPos targetPos
    computeCount cs targetPos (acc + stepsOnA)

-- Postcondition definitions
@[reducible, simp]
def countASteps_postcond (s : String) (result: Nat) (h_precond : countASteps_precond (s)) : Prop :=
  -- !benchmark @start postcond
  -- The result should equal the number of times we step on 'A' during the journey
  -- Starting from position 0 (character 'A'), we process each character in the string
  -- and count how many times we cross from Z to A (or stay/go back to A)
  result = computeCount s.toList 0 0
  -- !benchmark @end postcond


-- Proof content
theorem countASteps_postcond_satisfied (s: String) (h_precond : countASteps_precond (s)) :
    countASteps_postcond (s) (countASteps (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1235_p01938