import Mathlib.Data.List.Basic
import Mathlib.Data.String.Basic

namespace no_21632_codeexercises_121632


-- Precondition definitions
@[reducible, simp]
def article_word_frequency_precond (article : String) (threshold : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's already provided in postcond_aux

-- Main function definitions
def article_word_frequency (article : String) (threshold : Nat) (h_precond : article_word_frequency_precond (article) (threshold)) : List String :=
  -- !benchmark @start code
  let words := article.splitOn " " |>.filter (λ s => s ≠ "")
  let word_counts : List (String × Nat) := 
    let counts : List (String × Nat) := []
    words.foldl (λ counts word => 
      match counts.lookup word with
      | some count => (word, count + 1) :: counts.eraseP (λ (w, _) => w = word)
      | none => (word, 1) :: counts) []
  words.eraseDups.filter (λ word => 
    match word_counts.lookup word with
    | some count => count > threshold
    | none => False)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def word_frequency (article : String) (word : String) : Nat :=
  let words := article.splitOn " " |>.filter (λ s => s ≠ "")
  (words.filter (λ w => w = word)).length

def words_in_article (article : String) : List String :=
  article.splitOn " " |>.filter (λ s => s ≠ "") |>.eraseDups

-- Postcondition definitions
@[reducible, simp]
def article_word_frequency_postcond (article : String) (threshold : Nat) (result: List String) (h_precond : article_word_frequency_precond (article) (threshold)) : Prop :=
  -- !benchmark @start postcond
  (∀ word ∈ result, word_frequency article word > threshold) ∧
  (∀ word, word_frequency article word > threshold → word ∈ result) ∧
  (∀ word ∈ result, word ∈ words_in_article article)
  -- !benchmark @end postcond


-- Proof content
theorem article_word_frequency_postcond_satisfied (article: String) (threshold: Nat) (h_precond : article_word_frequency_precond (article) (threshold)) :
    article_word_frequency_postcond (article) (threshold) (article_word_frequency (article) (threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_21632_codeexercises_121632