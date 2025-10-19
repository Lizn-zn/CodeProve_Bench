import Mathlib

-- Precondition definitions
@[reducible, simp]
def list_with_unique_set_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def list_with_unique_set (nums : List Int) (h_precond : list_with_unique_set_precond (nums)) : Prod (List Int) (Set Int) :=
  -- !benchmark @start code
  let unique_set : Set Int := {x | x ∈ nums}
  (nums, unique_set)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def unique_elements (nums : List Int) : Set Int :=
  {x | ∃ i, nums.get? i = some x}

-- Postcondition definitions
@[reducible, simp]
def list_with_unique_set_postcond (nums : List Int) (result: Prod (List Int) (Set Int)) (h_precond : list_with_unique_set_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result.1 = nums ∧ result.2 = unique_elements nums
  -- !benchmark @end postcond


-- Proof content
theorem list_with_unique_set_postcond_satisfied (nums: List Int) (h_precond : list_with_unique_set_precond (nums)) :
    list_with_unique_set_postcond (nums) (list_with_unique_set (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof