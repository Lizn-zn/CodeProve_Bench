import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_words_precond (sentence1 : String) (sentence2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def words (s : String) : List String :=
  s.splitOn " " |>.filter (λ w => ¬w.isEmpty)

-- Main function definitions
def find_common_words (sentence1 : String) (sentence2 : String) (h_precond : find_common_words_precond (sentence1) (sentence2)) : List String :=
  -- !benchmark @start code
  let ws1 := words sentence1
  let ws2 := words sentence2
  ws1.filter (λ w => w ∈ ws2) |>.eraseDups
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isCommonWord (word : String) (s1 s2 : String) : Prop :=
  word ∈ words s1 ∧ word ∈ words s2

def allCommonWords (s1 s2 : String) : List String :=
  let ws1 := words s1
  let ws2 := words s2
  ws1.filter (λ w => w ∈ ws2) |>.eraseDups

-- Postcondition definitions
@[reducible, simp]
def find_common_words_postcond (sentence1 : String) (sentence2 : String) (result: List String) (h_precond : find_common_words_precond (sentence1) (sentence2)) : Prop :=
  -- !benchmark @start postcond
  result = allCommonWords sentence1 sentence2 ∧
  ∀ w, w ∈ result ↔ isCommonWord w sentence1 sentence2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_words_postcond_satisfied (sentence1: String) (sentence2: String) (h_precond : find_common_words_precond (sentence1) (sentence2)) :
    find_common_words_postcond (sentence1) (sentence2) (find_common_words (sentence1) (sentence2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof