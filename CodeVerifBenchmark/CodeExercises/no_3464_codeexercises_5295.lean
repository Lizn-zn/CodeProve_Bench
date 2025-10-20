import Mathlib

namespace no_3464_codeexercises_5295


-- Precondition definitions
@[reducible, simp]
def find_repeat_characters_precond (text : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences (text : String) (c : Char) : Nat :=
  text.foldl (λ count char => if char = c then count + 1 else count) 0

-- Main function definitions
def find_repeat_characters (text : String) (h_precond : find_repeat_characters_precond (text)) : Set Char :=
  -- !benchmark @start code
  let char_list := text.toList
  let repeating_chars : List Char := char_list.filter (λ c => count_occurrences text c > 1)
  repeating_chars.toFinset.toSet
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_repeating_char (text : String) (c : Char) : Prop :=
  count_occurrences text c > 1

-- Postcondition definitions
@[reducible, simp]
def find_repeat_characters_postcond (text : String) (result: Set Char) (h_precond : find_repeat_characters_precond (text)) : Prop :=
  -- !benchmark @start postcond
  ∀ (c : Char), c ∈ result ↔ is_repeating_char text c
  -- !benchmark @end postcond


-- Proof content
theorem find_repeat_characters_postcond_satisfied (text: String) (h_precond : find_repeat_characters_precond (text)) :
    find_repeat_characters_postcond (text) (find_repeat_characters (text) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3464_codeexercises_5295