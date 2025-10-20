import Mathlib

namespace no_3407_syn_1_iter_3407


-- Precondition definitions
@[reducible, simp]
def vowel_indices_precond (chars : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def isVowel (c : Char) : Bool :=
  let lower := c.toLower
  lower == 'a' || lower == 'e' || lower == 'i' || lower == 'o' || lower == 'u'

-- Main function definitions
def vowel_indices (chars : List Char) (h_precond : vowel_indices_precond (chars)) : Finset Nat :=
  -- !benchmark @start code
  let vowel_indices := List.range chars.length |>.filter (λ i => isVowel (chars.get! i))
  vowel_indices.toFinset
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Postcondition definitions
@[reducible, simp]
def vowel_indices_postcond (chars : List Char) (result: Finset Nat) (h_precond : vowel_indices_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  result = ((List.enum chars).filter (λ p => isVowel p.snd) |>.map Prod.fst).toFinset
  -- !benchmark @end postcond


-- Proof content
theorem vowel_indices_postcond_satisfied (chars: List Char) (h_precond : vowel_indices_precond (chars)) :
    vowel_indices_postcond (chars) (vowel_indices (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3407_syn_1_iter_3407