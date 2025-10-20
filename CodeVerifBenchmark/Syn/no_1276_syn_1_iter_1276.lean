import Mathlib

namespace no_1276_syn_1_iter_1276


-- Precondition definitions
@[reducible, simp]
def square_list_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def square_list (nums : List Nat) (h_precond : square_list_precond (nums)) : List Nat :=
  -- !benchmark @start code
  match nums with
  | [] => []
  | h :: t => (h * h) :: square_list t (by simp [square_list_precond])
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def square_list_postcond (nums : List Nat) (result: List Nat) (h_precond : square_list_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = nums.map (λ x => x * x)
  -- !benchmark @end postcond


-- Proof content
theorem square_list_postcond_satisfied (nums: List Nat) (h_precond : square_list_precond (nums)) :
    square_list_postcond (nums) (square_list (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1276_syn_1_iter_1276