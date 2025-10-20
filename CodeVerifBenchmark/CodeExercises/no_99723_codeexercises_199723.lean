import Mathlib

namespace no_99723_codeexercises_199723


-- Precondition definitions
@[reducible, simp]
def count_vowels_consonants_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isVowel (c : Char) : Bool :=
  let lower := c.toLower
  lower == 'a' || lower == 'e' || lower == 'i' || lower == 'o' || lower == 'u'

def isConsonant (c : Char) : Bool :=
  let lower := c.toLower
  c.isAlpha ∧ ¬(isVowel c)

-- Main function definitions
def count_vowels_consonants (s : String) (h_precond : count_vowels_consonants_precond (s)) : Prod Nat Nat :=
  -- !benchmark @start code
  let vowels := s.foldl (λ acc c => if isVowel c then acc + 1 else acc) 0
  let consonants := s.foldl (λ acc c => if isConsonant c then acc + 1 else acc) 0
  (vowels, consonants)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (isVowel and isConsonant moved above since they're needed in the code)

-- Postcondition definitions
@[reducible, simp]
def count_vowels_consonants_postcond (s : String) (result: Prod Nat Nat) (h_precond : count_vowels_consonants_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let (vowels, consonants) := result
  vowels = (s.toList.filter isVowel).length ∧
  consonants = (s.toList.filter isConsonant).length
  -- !benchmark @end postcond


-- Proof content
theorem count_vowels_consonants_postcond_satisfied (s: String) (h_precond : count_vowels_consonants_precond (s)) :
    count_vowels_consonants_postcond (s) (count_vowels_consonants (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_99723_codeexercises_199723