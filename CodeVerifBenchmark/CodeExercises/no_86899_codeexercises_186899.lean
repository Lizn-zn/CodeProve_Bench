import Mathlib

namespace no_86899_codeexercises_186899


-- Precondition definitions
@[reducible, simp]
def find_common_characters_precond (string1 : String) (string2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_characters (string1 : String) (string2 : String) (h_precond : find_common_characters_precond (string1) (string2)) : List Char :=
  -- !benchmark @start code
  let chars1 := string1.toList
  let chars2 := string2.toList
  let result := chars1.filter (λ c => chars2.contains c ∧ ¬(chars1.take (chars1.indexOf c)).contains c)
  result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_chars (s1 s2 : String) : List Char :=
  let chars1 := s1.toList
  let chars2 := s2.toList
  chars1.filter (λ c => chars2.contains c) |>.eraseDups

-- Postcondition definitions
@[reducible, simp]
def find_common_characters_postcond (string1 : String) (string2 : String) (result: List Char) (h_precond : find_common_characters_precond (string1) (string2)) : Prop :=
  -- !benchmark @start postcond
  result = common_chars string1 string2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_characters_postcond_satisfied (string1: String) (string2: String) (h_precond : find_common_characters_precond (string1) (string2)) :
    find_common_characters_postcond (string1) (string2) (find_common_characters (string1) (string2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_86899_codeexercises_186899