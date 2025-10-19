import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (arr1 : Array Int) (arr2 : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements (arr1 : Array Int) (arr2 : Array Int) (h_precond : find_common_elements_precond (arr1) (arr2)) : Set Int :=
  -- !benchmark @start code
  Id.run do
    let mut result_set : Set Int := ∅
    for i in [0:arr1.size] do
      let x := arr1[i]!
      if arr2.contains x then
        result_set := result_set.insert x
    return result_set
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def common_elements (arr1 : Array Int) (arr2 : Array Int) : Set Int :=
  {x | ∃ i, i < arr1.size ∧ arr1[i]! = x ∧ ∃ j, j < arr2.size ∧ arr2[j]! = x}

-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (arr1 : Array Int) (arr2 : Array Int) (result: Set Int) (h_precond : find_common_elements_precond (arr1) (arr2)) : Prop :=
  -- !benchmark @start postcond
  result = common_elements arr1 arr2
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (arr1: Array Int) (arr2: Array Int) (h_precond : find_common_elements_precond (arr1) (arr2)) :
    find_common_elements_postcond (arr1) (arr2) (find_common_elements (arr1) (arr2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof