import Mathlib

namespace no_828_leetcode_1657


-- Precondition auxiliary definitions
def charCount (s : String) : List Nat :=
  let counts := s.data.foldl (fun (acc : Array Nat) (c : Char) =>
    let idx := c.val.toNat - 'a'.val.toNat
    if idx < 26 then
      if idx < acc.size then
        let new_count := acc[idx]! + 1
        acc.set! idx new_count
      else
        -- This case shouldn't happen if we initialize correctly, but for safety
        acc.push 1
    else
      acc
  ) (Array.mkArray 26 0)
  counts.toList

def sortedCharCounts (s : String) : List Nat :=
  (charCount s).mergeSort (· ≤ ·)

def hasSameCharacters (s1 s2 : String) : Prop :=
  ∀ c : Char, (s1.contains c ↔ s2.contains c)

-- Precondition definitions
@[reducible, simp]
def closeStrings_precond (word1 : String) (word2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def charSet (s : String) : List Bool :=
  let present := s.data.foldl (fun (acc : Array Bool) (c : Char) =>
    let idx := c.val.toNat - 'a'.val.toNat
    if idx < 26 then
      if idx < acc.size then
        acc.set! idx true
      else
        -- This case shouldn't happen if we initialize correctly, but for safety
        acc.push true
    else
      acc
  ) (Array.mkArray 26 false)
  present.toList

-- Main function definitions
def closeStrings (word1 : String) (word2 : String) (h_precond : closeStrings_precond (word1) (word2)) : Bool :=
  -- !benchmark @start code
  let chars1 := charSet word1
  let chars2 := charSet word2
  if chars1 ≠ chars2 then
    false
  else
    let counts1 := sortedCharCounts word1
    let counts2 := sortedCharCounts word2
    counts1 = counts2
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def closeStrings_postcond (word1 : String) (word2 : String) (result: Bool) (h_precond : closeStrings_precond (word1) (word2)) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ (hasSameCharacters word1 word2 ∧ sortedCharCounts word1 = sortedCharCounts word2)
  -- !benchmark @end postcond


-- Proof content
theorem closeStrings_postcond_satisfied (word1: String) (word2: String) (h_precond : closeStrings_precond (word1) (word2)) :
    closeStrings_postcond (word1) (word2) (closeStrings (word1) (word2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_828_leetcode_1657