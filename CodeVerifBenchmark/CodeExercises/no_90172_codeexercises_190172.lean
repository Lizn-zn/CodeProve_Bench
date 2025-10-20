import Mathlib

namespace no_90172_codeexercises_190172


-- Precondition definitions
@[reducible, simp]
def append_new_elements_precond (historical_data : List α) (new_elements : List α) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def append_new_elements [DecidableEq α] (historical_data : List α) (new_elements : List α) (h_precond : append_new_elements_precond historical_data new_elements) : List α :=
  -- !benchmark @start code
  let unique_new := new_elements.filter (λ x => ¬(x ∈ historical_data))
  historical_data ++ unique_new
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_subset_of (xs : List α) (ys : List α) : Prop :=
  ∀ x, x ∈ xs → x ∈ ys

def elements_unique [DecidableEq α] (xs : List α) : Prop :=
  ∀ x, x ∈ xs → List.count x xs = 1

-- Postcondition definitions
@[reducible, simp]
def append_new_elements_postcond [DecidableEq α] (historical_data : List α) (new_elements : List α) (result: List α) (h_precond : append_new_elements_precond historical_data new_elements) : Prop :=
  -- !benchmark @start postcond
  let unique_new := new_elements.filter (λ x => ¬(x ∈ historical_data))
  result = historical_data ++ unique_new ∧
  is_subset_of result (historical_data ++ new_elements) ∧
  elements_unique result
  -- !benchmark @end postcond


-- Proof content
theorem append_new_elements_postcond_satisfied [DecidableEq α] (historical_data: List α) (new_elements: List α) (h_precond : append_new_elements_precond historical_data new_elements) :
    append_new_elements_postcond historical_data new_elements (append_new_elements historical_data new_elements h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_90172_codeexercises_190172