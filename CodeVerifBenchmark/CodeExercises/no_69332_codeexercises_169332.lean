import Mathlib

namespace no_69332_codeexercises_169332


-- Precondition definitions
@[reducible, simp]
def append_patterns_precond (patterns : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def append_patterns (patterns : List String) (h_precond : append_patterns_precond (patterns)) : List String :=
  -- !benchmark @start code
  match patterns with
  | [] => []
  | _ => patterns.flatMap (λ pattern => 
        List.range 3 |>.map (λ i => pattern ++ toString (i + 1)))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_result (patterns : List String) : List String :=
  patterns.flatMap (λ pattern => List.range 3 |>.map (λ i => pattern ++ toString (i + 1)))

-- Postcondition definitions
@[reducible, simp]
def append_patterns_postcond (patterns : List String) (result: List String) (h_precond : append_patterns_precond (patterns)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result patterns
  -- !benchmark @end postcond


-- Proof content
theorem append_patterns_postcond_satisfied (patterns: List String) (h_precond : append_patterns_precond (patterns)) :
    append_patterns_postcond (patterns) (append_patterns (patterns) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_69332_codeexercises_169332