import Mathlib

namespace no_34868_codeexercises_134868


-- Precondition definitions
@[reducible, simp]
def delete_elements_precond (collection : List α) (items : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def delete_elements [BEq α] (collection : List α) (items : List α) (h_precond : delete_elements_precond (collection) (items)) : List α :=
  -- !benchmark @start code
  List.filter (λ x => ¬(items.contains x)) collection
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.filterNotMem [BEq α] (l : List α) (items : List α) : List α :=
  l.filter (λ x => ¬(items.contains x))

-- Postcondition definitions
@[reducible, simp]
def delete_elements_postcond [BEq α] (collection : List α) (items : List α) (result: List α) (h_precond : delete_elements_precond (collection) (items)) : Prop :=
  -- !benchmark @start postcond
  result = List.filterNotMem collection items
  -- !benchmark @end postcond


-- Proof content
theorem delete_elements_postcond_satisfied [BEq α] (collection: List α) (items: List α) (h_precond : delete_elements_precond (collection) (items)) :
    delete_elements_postcond (collection) (items) (delete_elements (collection) (items) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_34868_codeexercises_134868