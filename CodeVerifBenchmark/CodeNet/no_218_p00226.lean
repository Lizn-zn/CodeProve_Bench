import Mathlib

-- Precondition definitions
@[reducible, simp]
def countHitsAndBlows_precond (correct : String) (answer : String) : Prop :=
  -- !benchmark @start precond
  -- Both strings must be exactly 4 characters long
  correct.length = 4 ∧ answer.length = 4 ∧
  -- All characters must be digits (0-9)
  (∀ i : Fin 4, (correct.get ⟨i.val⟩).isDigit) ∧
  (∀ i : Fin 4, (answer.get ⟨i.val⟩).isDigit)
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to convert a character to a digit (assuming it's already a digit)
def charToDigit (c : Char) : Nat :=
  c.toNat - '0'.toNat

-- Helper function to count hits
def countHitsImpl (correct answer : String) : Nat :=
  let rec loop (i : Nat) (acc : Nat) : Nat :=
    if h : i < 4 then
      let hit := if correct.get ⟨i⟩ == answer.get ⟨i⟩ then 1 else 0
      loop (i + 1) (acc + hit)
    else
      acc
  loop 0 0

-- Helper function to count total matches
def countTotalMatchesImpl (correct answer : String) : Nat :=
  let rec outerLoop (i : Nat) (acc : Nat) : Nat :=
    if h : i < 4 then
      let answerChar := answer.get ⟨i⟩
      let rec innerLoop (j : Nat) (innerAcc : Nat) : Nat :=
        if h' : j < 4 then
          let matchCount := if correct.get ⟨j⟩ == answerChar then 1 else 0
          innerLoop (j + 1) (innerAcc + matchCount)
        else
          innerAcc
      outerLoop (i + 1) (acc + innerLoop 0 0)
    else
      acc
  outerLoop 0 0

-- Main function definitions
def countHitsAndBlows (correct : String) (answer : String) (h_precond : countHitsAndBlows_precond (correct) (answer)) : Nat × Nat :=
  -- !benchmark @start code
  let hits := countHitsImpl correct answer
  let totalMatches := countTotalMatchesImpl correct answer
  let blows := totalMatches - hits
  (hits, blows)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Count hits: positions where both digit and position match
def countHits (correct answer : String) : Nat :=
  (List.range 4).countP (fun i => correct.get ⟨i⟩ == answer.get ⟨i⟩)

-- Count total matches: positions where the digit from answer appears anywhere in correct
def countTotalMatches (correct answer : String) : Nat :=
  (List.range 4).foldl (fun acc i =>
    let answerChar := answer.get ⟨i⟩
    acc + (List.range 4).countP (fun j => correct.get ⟨j⟩ == answerChar)
  ) 0

-- Postcondition definitions
@[reducible, simp]
def countHitsAndBlows_postcond (correct : String) (answer : String) (result: Nat × Nat) (h_precond : countHitsAndBlows_precond (correct) (answer)) : Prop :=
  -- !benchmark @start postcond
  -- result.1 is the number of hits (exact position and digit matches)
  result.1 = countHits correct answer ∧
  -- result.2 is the number of blows (digit matches but wrong position)
  -- This is calculated as total matches minus hits
  result.2 = countTotalMatches correct answer - countHits correct answer
  -- !benchmark @end postcond


-- Proof content
theorem countHitsAndBlows_postcond_satisfied (correct: String) (answer: String) (h_precond : countHitsAndBlows_precond (correct) (answer)) :
    countHitsAndBlows_postcond (correct) (answer) (countHitsAndBlows (correct) (answer) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof