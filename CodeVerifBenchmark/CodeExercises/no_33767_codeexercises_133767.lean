import Mathlib

namespace no_33767_codeexercises_133767


-- Precondition definitions
@[reducible, simp]
def modify_list_precond (values : List Int) (modifier : Int) : Prop :=
  -- !benchmark @start precond
  modifier ≠ 0
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def modify_list (values : List Int) (modifier : Int) (h_precond : modify_list_precond (values) (modifier)) : List Int :=
  -- !benchmark @start code
  List.map (λ x => x % modifier) values
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def modify_list_postcond (values : List Int) (modifier : Int) (result: List Int) (h_precond : modify_list_precond (values) (modifier)) : Prop :=
  -- !benchmark @start postcond
  result.length = values.length ∧
  ∀ (i : Fin result.length), result[i]! = values[i]! % modifier
  -- !benchmark @end postcond


-- Proof content
theorem modify_list_postcond_satisfied (values: List Int) (modifier: Int) (h_precond : modify_list_precond (values) (modifier)) :
    modify_list_postcond (values) (modifier) (modify_list (values) (modifier) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_33767_codeexercises_133767