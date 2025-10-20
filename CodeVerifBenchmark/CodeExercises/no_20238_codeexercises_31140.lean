import Mathlib

namespace no_20238_codeexercises_31140


-- Precondition definitions
@[reducible, simp]
def find_artifacts_precond (artifacts_list : List String) (num_times : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def find_artifacts (artifacts_list : List String) (num_times : Nat) (h_precond : find_artifacts_precond (artifacts_list) (num_times)) : List String :=
  -- !benchmark @start code
  match num_times with
  | 0 => []
  | n + 1 => artifacts_list ++ find_artifacts artifacts_list n h_precond
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def repeat_list (l : List String) (n : Nat) : List String :=
  match n with
  | 0 => []
  | n + 1 => l ++ repeat_list l n

-- Postcondition definitions
@[reducible, simp]
def find_artifacts_postcond (artifacts_list : List String) (num_times : Nat) (result: List String) (h_precond : find_artifacts_precond (artifacts_list) (num_times)) : Prop :=
  -- !benchmark @start postcond
  result = repeat_list artifacts_list num_times
  -- !benchmark @end postcond


-- Proof content
theorem find_artifacts_postcond_satisfied (artifacts_list: List String) (num_times: Nat) (h_precond : find_artifacts_precond (artifacts_list) (num_times)) :
    find_artifacts_postcond (artifacts_list) (num_times) (find_artifacts (artifacts_list) (num_times) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_20238_codeexercises_31140