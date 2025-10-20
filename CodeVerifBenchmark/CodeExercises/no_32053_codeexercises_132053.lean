import Mathlib

namespace no_32053_codeexercises_132053


-- Precondition definitions
@[reducible, simp]
def count_unique_chars_precond (word : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def count_unique_chars (word : String) (h_precond : count_unique_chars_precond (word)) : Nat :=
  -- !benchmark @start code
  let seen : Finset Char := word.toList.foldl (λ s c => s ∪ {c}) ∅
  seen.card
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def unique_chars (s : String) : Finset Char :=
  s.toList.toFinset

-- Postcondition definitions
@[reducible, simp]
def count_unique_chars_postcond (word : String) (result: Nat) (h_precond : count_unique_chars_precond (word)) : Prop :=
  -- !benchmark @start postcond
  result = (unique_chars word).card
  -- !benchmark @end postcond


-- Proof content
theorem count_unique_chars_postcond_satisfied (word: String) (h_precond : count_unique_chars_precond (word)) :
    count_unique_chars_postcond (word) (count_unique_chars (word) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_32053_codeexercises_132053