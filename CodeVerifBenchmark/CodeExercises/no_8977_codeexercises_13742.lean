import Mathlib

namespace no_8977_codeexercises_13742


-- Precondition definitions
@[reducible, simp]
def copy_and_operation_precond (original_list : List Bool) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple operation

-- Main function definitions
def copy_and_operation (original_list : List Bool) (h_precond : copy_and_operation_precond (original_list)) : Bool :=
  -- !benchmark @start code
  match original_list with
  | [] => true
  | h::t => 
    let copied_list := original_list
    let result := List.foldl (λ acc x => acc && x) h t
    result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def fold_and : List Bool → Bool
  | [] => true
  | h::t => h && fold_and t

-- Postcondition definitions
@[reducible, simp]
def copy_and_operation_postcond (original_list : List Bool) (result: Bool) (h_precond : copy_and_operation_precond (original_list)) : Prop :=
  -- !benchmark @start postcond
  result = fold_and original_list
  -- !benchmark @end postcond


-- Proof content
theorem copy_and_operation_postcond_satisfied (original_list: List Bool) (h_precond : copy_and_operation_precond (original_list)) :
    copy_and_operation_postcond (original_list) (copy_and_operation (original_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8977_codeexercises_13742