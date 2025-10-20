import Mathlib

namespace no_22958_codeexercises_122958


-- Precondition definitions
@[reducible, simp]
def capitalize_words_precond (set_of_words : Set String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Postcondition auxiliary definitions
def capitalize_word (s : String) : String :=
  match s.data with
  | [] => ""
  | c :: cs => String.mk (Char.toUpper c :: cs)

-- Main function definitions
def capitalize_words (set_of_words : Set String) (h_precond : capitalize_words_precond (set_of_words)) : Set String :=
  -- !benchmark @start code
  let capitalized_words := set_of_words.image capitalize_word
  capitalized_words
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def capitalize_words_postcond (set_of_words : Set String) (result: Set String) (h_precond : capitalize_words_precond (set_of_words)) : Prop :=
  -- !benchmark @start postcond
  ∀ w, w ∈ result ↔ ∃ w', w' ∈ set_of_words ∧ w = capitalize_word w'
  -- !benchmark @end postcond


-- Proof content
theorem capitalize_words_postcond_satisfied (set_of_words: Set String) (h_precond : capitalize_words_precond (set_of_words)) :
    capitalize_words_postcond (set_of_words) (capitalize_words (set_of_words) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_22958_codeexercises_122958