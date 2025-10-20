import Mathlib

namespace no_77806_codeexercises_177806


-- Precondition definitions
@[reducible, simp]
def get_unique_words_precond (text : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def words (s : String) : List String :=
  s.split (λ c => c = ' ' || c = '\n' || c = '\t' || c = '\r' || c = '.' || c = '!' || c = '?' || c = ',' || c = ';' || c = ':' || c = '"' || c = '\'' || c = '(' || c = ')' || c = '[' || c = ']' || c = '{' || c = '}')

-- Main function definitions
def get_unique_words (text : String) (h_precond : get_unique_words_precond text) : List String :=
  -- !benchmark @start code
  let words_list := words text
  let filtered_words := words_list.filter (λ w => ¬w.isEmpty)
  filtered_words.eraseDups
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_unique_list (l : List String) : Prop :=
  ∀ x, x ∈ l → l.count x = 1

def same_elements (l1 l2 : List String) : Prop :=
  ∀ x, x ∈ l1 ↔ x ∈ l2

-- Postcondition definitions
@[reducible, simp]
def get_unique_words_postcond (text : String) (result : List String) (h_precond : get_unique_words_precond text) : Prop :=
  -- !benchmark @start postcond
  let words_list := words text
  is_unique_list result ∧ same_elements result words_list
  -- !benchmark @end postcond


-- Proof content
theorem get_unique_words_postcond_satisfied (text : String) (h_precond : get_unique_words_precond text) :
    get_unique_words_postcond text (get_unique_words text h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_77806_codeexercises_177806