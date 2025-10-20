import Mathlib

namespace no_1629_leetcode_2000


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def reversePrefix_precond (word : String) (ch : Char) : Prop :=
  -- !benchmark @start precond
  word.length > 0 ∧ word.length ≤ 250 ∧ 
  ∀ c ∈ word.data, c.isLower ∧ 
  ch.isLower
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Find the first occurrence of a character in a string -/
def findFirstIndex (s : String) (c : Char) : Option Nat :=
  let chars := s.data
  let indexedChars := List.zip chars (List.range chars.length)
  match indexedChars.find? (fun (ch', idx) => ch' = c) with
  | some (_, idx) => some idx
  | none => none

/-- Reverse the prefix of a list up to and including the given index -/
def reversePrefixList (l : List Char) (idx : Nat) : List Char :=
  if h : idx < l.length then
    let pref := l.take (idx + 1)
    let suffix := l.drop (idx + 1)
    pref.reverse ++ suffix
  else
    l

-- Main function definitions
def reversePrefix (word : String) (ch : Char) (h_precond : reversePrefix_precond word ch) : String :=
  -- !benchmark @start code
  let chars := word.data
  match findFirstIndex word ch with
  | some idx => 
      let reversed := reversePrefixList chars idx
      String.mk reversed
  | none =>
      word
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Find the first occurrence of a character in a string 
def findFirstIndex' (s : String) (c : Char) : Option Nat :=
  let chars := s.data
  let indexedChars := List.zip chars (List.range chars.length)
  match indexedChars.find? (fun (ch', idx) => ch' = c) with
  | some (_, idx) => some idx
  | none => none

/-- Reverse the prefix of a list up to and including the given index -/
def reversePrefixList' (l : List Char) (idx : Nat) : List Char :=
  if h : idx < l.length then
    let pref := l.take (idx + 1)
    let suffix := l.drop (idx + 1)
    pref.reverse ++ suffix
  else
    l

-- Postcondition definitions
@[reducible, simp]
def reversePrefix_postcond (word : String) (ch : Char) (result: String) (h_precond : reversePrefix_precond word ch) : Prop :=
  -- !benchmark @start postcond
  let chars := word.data
  let resultChars := result.data
  match findFirstIndex' word ch with
  | some idx => 
      let expected := reversePrefixList' chars idx
      resultChars = expected
  | none =>
      resultChars = chars
  -- !benchmark @end postcond


-- Proof content
theorem reversePrefix_postcond_satisfied (word: String) (ch: Char) (h_precond : reversePrefix_precond word ch) :
    reversePrefix_postcond word ch (reversePrefix word ch h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1629_leetcode_2000