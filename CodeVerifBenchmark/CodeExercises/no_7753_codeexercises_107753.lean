import Mathlib

namespace no_7753_codeexercises_107753


-- Precondition definitions
@[reducible, simp]
def find_common_words_precond (texts : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def words (s : String) : Set String :=
  s.splitOn " " |>.filter (λ w => ¬w.isEmpty) |>.map String.toLower |>.toFinset |>.toSet

-- Main function definitions
def find_common_words (texts : List String) (h_precond : find_common_words_precond (texts)) : Set String :=
  -- !benchmark @start code
  match texts with
  | [] => Set.univ
  | hd::tl => 
    let initial_words := words hd
    List.foldl (λ acc text => Set.inter acc (words text)) initial_words tl
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_words (texts : List String) : Set String :=
  match texts with
  | [] => Set.univ
  | hd::tl => List.foldl (λ acc text => acc ∩ words text) (words hd) tl

-- Postcondition definitions
@[reducible, simp]
def find_common_words_postcond (texts : List String) (result: Set String) (h_precond : find_common_words_precond (texts)) : Prop :=
  -- !benchmark @start postcond
  result = common_words texts
  -- !benchmark @end postcond


-- Proof content
theorem find_common_words_postcond_satisfied (texts: List String) (h_precond : find_common_words_precond (texts)) :
    find_common_words_postcond (texts) (find_common_words (texts) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7753_codeexercises_107753