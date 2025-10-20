import Mathlib

namespace no_39773_codeexercises_139773


-- Precondition definitions
@[reducible, simp]
def find_common_chars_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed beyond what's already provided

-- Main function definitions
def find_common_chars (s1 : String) (s2 : String) (h_precond : find_common_chars_precond s1 s2) : String :=
  -- !benchmark @start code
  let common_chars_list := s1.data.filter (λ c => s2.contains c)
  String.mk common_chars_list
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def chars_in_order (s : String) (chars : List Char) : Prop :=
  ∃ (l : List Char), l = s.data ∧ chars = l.filter (λ c => chars.contains c)

def common_chars (s1 s2 : String) : List Char :=
  s1.data.filter (λ c => s2.contains c)

-- Postcondition definitions
@[reducible, simp]
def find_common_chars_postcond (s1 : String) (s2 : String) (result: String) (h_precond : find_common_chars_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  result.data = common_chars s1 s2 ∧ chars_in_order s1 result.data
  -- !benchmark @end postcond


-- Proof content
theorem find_common_chars_postcond_satisfied (s1: String) (s2: String) (h_precond : find_common_chars_precond s1 s2) :
    find_common_chars_postcond s1 s2 (find_common_chars s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_39773_codeexercises_139773