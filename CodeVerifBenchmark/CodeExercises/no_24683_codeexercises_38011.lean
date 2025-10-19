import Mathlib

-- Precondition auxiliary definitions
def isVowel (c : Char) : Bool :=
  c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
  c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U'

def vowels : List Char := ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']

def findClosestVowel (c : Char) : Char :=
  let vowelDists : List (Char × ℕ) := vowels.map (λ v => (v, Int.natAbs (c.toNat - v.toNat)))
  let minDist := vowelDists.foldl (λ min dist => if dist.2 < min.2 then dist else min) ('a', c.toNat)
  minDist.1

-- Precondition definitions
@[reducible, simp]
def find_closest_vowel_precond (name : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed

-- Main function definitions
def find_closest_vowel (name : String) (h_precond : find_closest_vowel_precond (name)) : List Char :=
  -- !benchmark @start code
  name.data.map (λ c => 
    if isVowel c then c else findClosestVowel c)
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_closest_vowel_postcond (name : String) (result: List Char) (h_precond : find_closest_vowel_precond (name)) : Prop :=
  -- !benchmark @start postcond
  result = name.data.map (λ c => 
    if isVowel c then c else findClosestVowel c)
  -- !benchmark @end postcond


-- Proof content
theorem find_closest_vowel_postcond_satisfied (name: String) (h_precond : find_closest_vowel_precond (name)) :
    find_closest_vowel_postcond (name) (find_closest_vowel (name) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof