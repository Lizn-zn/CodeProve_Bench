import Mathlib

-- Precondition definitions
@[reducible, simp]
def calculate_average_word_length_precond (text : List String) : Prop :=
  -- !benchmark @start precond
  ∀ s ∈ text, ∀ word ∈ s.splitOn " ", word.length > 0
  -- !benchmark @end precond


-- Code auxiliary definitions
def total_words_and_length (text : List String) : Nat × Nat :=
  text.foldl (λ (total_words, total_length) sentence =>
    let words := sentence.splitOn " "
    (total_words + words.length, total_length + (words.map String.length).sum)
  ) (0, 0)

-- Main function definitions
def calculate_average_word_length (text : List String) (h_precond : calculate_average_word_length_precond (text)) : Float :=
  -- !benchmark @start code
  let (total_words, total_length) := total_words_and_length text
  (total_length.toFloat : Float) / (total_words.toFloat : Float)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- (total_words_and_length is already defined above)

-- Postcondition definitions
@[reducible, simp]
def calculate_average_word_length_postcond (text : List String) (result: Float) (h_precond : calculate_average_word_length_precond (text)) : Prop :=
  -- !benchmark @start postcond
  let (total_words, total_length) := total_words_and_length text
  total_words > 0 ∧ result = (total_length.toFloat : Float) / (total_words.toFloat : Float)
  -- !benchmark @end postcond


-- Proof content
theorem calculate_average_word_length_postcond_satisfied (text: List String) (h_precond : calculate_average_word_length_precond (text)) :
    calculate_average_word_length_postcond (text) (calculate_average_word_length (text) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof