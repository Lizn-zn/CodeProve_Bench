import Mathlib

namespace no_14811_codeexercises_22797


-- Precondition definitions
@[reducible, simp]
def count_vowels_precond (text : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def count_vowels (text : String) (h_precond : count_vowels_precond (text)) : Nat :=
  -- !benchmark @start code
  let vowels := "aeiouAEIOU"
  let result := text.foldl (λ acc c => if vowels.contains c then acc + 1 else acc) 0
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isVowel (c : Char) : Bool :=
  c = 'a' || c = 'e' || c = 'i' || c = 'o' || c = 'u' ||
  c = 'A' || c = 'E' || c = 'I' || c = 'O' || c = 'U'

-- Postcondition definitions
@[reducible, simp]
def count_vowels_postcond (text : String) (result: Nat) (h_precond : count_vowels_precond (text)) : Prop :=
  -- !benchmark @start postcond
  result = (text.toList.filter isVowel).length
  -- !benchmark @end postcond


-- Proof content
theorem count_vowels_postcond_satisfied (text: String) (h_precond : count_vowels_precond (text)) :
    count_vowels_postcond (text) (count_vowels (text) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_14811_codeexercises_22797