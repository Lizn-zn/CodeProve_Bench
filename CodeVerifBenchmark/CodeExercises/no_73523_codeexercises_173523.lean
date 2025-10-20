import Mathlib

namespace no_73523_codeexercises_173523


-- Precondition definitions
@[reducible, simp]
def find_uppercase_letters_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary code needed for this implementation

-- Main function definitions
def find_uppercase_letters (s : String) (h_precond : find_uppercase_letters_precond (s)) : List Char :=
  -- !benchmark @start code
  s.data.filter (λ c => 'A' ≤ c ∧ c ≤ 'Z')
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_uppercase (c : Char) : Bool :=
  'A' ≤ c ∧ c ≤ 'Z'

-- Postcondition definitions
@[reducible, simp]
def find_uppercase_letters_postcond (s : String) (result: List Char) (h_precond : find_uppercase_letters_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result = s.data.filter is_uppercase
  -- !benchmark @end postcond


-- Proof content
theorem find_uppercase_letters_postcond_satisfied (s: String) (h_precond : find_uppercase_letters_precond (s)) :
    find_uppercase_letters_postcond (s) (find_uppercase_letters (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_73523_codeexercises_173523