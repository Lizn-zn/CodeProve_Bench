import Mathlib

namespace no_34134_codeexercises_52619


-- Precondition definitions
@[reducible, simp]
def find_common_chars_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_chars (s1 : String) (s2 : String) (h_precond : find_common_chars_precond (s1) (s2)) : Set Char :=
  -- !benchmark @start code
  let chars1 := s1.toList.toFinset
  let chars2 := s2.toList.toFinset
  chars1 ∩ chars2
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_chars (s1 s2 : String) : Set Char :=
  {c | s1.contains c ∧ s2.contains c}

-- Postcondition definitions
@[reducible, simp]
def find_common_chars_postcond (s1 : String) (s2 : String) (result: Set Char) (h_precond : find_common_chars_precond (s1) (s2)) : Prop :=
  -- !benchmark @start postcond
  result = common_chars s1 s2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_chars_postcond_satisfied (s1: String) (s2: String) (h_precond : find_common_chars_precond (s1) (s2)) :
    find_common_chars_postcond (s1) (s2) (find_common_chars (s1) (s2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34134_codeexercises_52619