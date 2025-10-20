import Mathlib

namespace no_12600_codeexercises_112600


-- Precondition definitions
@[reducible, simp]
def reverse_words_precond (sentence : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def reverse_words (sentence : String) (h_precond : reverse_words_precond (sentence)) : String :=
  -- !benchmark @start code
  let words_list := sentence.splitOn " " |>.filter (λ w => ¬ w.isEmpty)
  let reversed_words := List.range words_list.length |>.foldl (λ acc i => 
    words_list.get! (words_list.length - 1 - i) :: acc) []
  reversed_words.intersperse " " |>.foldl (λ acc s => acc ++ s) ""
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def words (s : String) : List String :=
  s.splitOn " " |>.filter (λ w => ¬ w.isEmpty)

-- Postcondition definitions
@[reducible, simp]
def reverse_words_postcond (sentence : String) (result: String) (h_precond : reverse_words_precond (sentence)) : Prop :=
  -- !benchmark @start postcond
  let input_words := words sentence
  let output_words := words result
  output_words = input_words.reverse
  -- !benchmark @end postcond


-- Proof content
theorem reverse_words_postcond_satisfied (sentence: String) (h_precond : reverse_words_precond (sentence)) :
    reverse_words_postcond (sentence) (reverse_words (sentence) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_12600_codeexercises_112600