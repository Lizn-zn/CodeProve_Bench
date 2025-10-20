import Mathlib

namespace no_38592_codeexercises_138592


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def is_suspect_caught_precond (suspects : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for code implementation

-- Main function definitions
def is_suspect_caught (suspects : List String) (h_precond : is_suspect_caught_precond (suspects)) : Bool :=
  -- !benchmark @start code
  suspects.all (λ suspect => ¬(suspect.contains 'a' || suspect.contains 'e' || suspect.contains 'i' || suspect.contains 'o' || suspect.contains 'u'))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def has_no_vowels (s : String) : Bool :=
  ¬(s.contains 'a' ∨ s.contains 'e' ∨ s.contains 'i' ∨ s.contains 'o' ∨ s.contains 'u')

-- Postcondition definitions
@[reducible, simp]
def is_suspect_caught_postcond (suspects : List String) (result: Bool) (h_precond : is_suspect_caught_precond (suspects)) : Prop :=
  -- !benchmark @start postcond
  result = ∀ (suspect : String), suspect ∈ suspects → has_no_vowels suspect
  -- !benchmark @end postcond


-- Proof content
theorem is_suspect_caught_postcond_satisfied (suspects: List String) (h_precond : is_suspect_caught_precond (suspects)) :
    is_suspect_caught_postcond (suspects) (is_suspect_caught (suspects) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_38592_codeexercises_138592