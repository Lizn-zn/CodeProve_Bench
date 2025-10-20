import Mathlib

namespace no_9515_syn_1_iter_9515


-- Precondition definitions
@[reducible, simp]
def set_to_array_precond (s : Set Int) : Prop :=
  -- !benchmark @start precond
  Set.Finite s
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
noncomputable def set_to_array (s : Set Int) (h_precond : set_to_array_precond (s)) : Array Int :=
  -- !benchmark @start code
  let h_finite : Set.Finite s := h_precond
  let elements := Finset.toList (h_finite.toFinset)
  let unique_elements := List.eraseDup elements
  List.toArray unique_elements
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def array_to_set (arr : Array Int) : Set Int :=
  {x | ∃ i, i < arr.size ∧ arr[i]! = x}

-- Postcondition definitions
@[reducible, simp]
def set_to_array_postcond (s : Set Int) (result: Array Int) (h_precond : set_to_array_precond (s)) : Prop :=
  -- !benchmark @start postcond
  array_to_set result = s ∧ ∀ i j, i < result.size → j < result.size → i ≠ j → result[i]! ≠ result[j]!
  -- !benchmark @end postcond


-- Proof content
theorem set_to_array_postcond_satisfied (s: Set Int) (h_precond : set_to_array_precond (s)) :
    set_to_array_postcond (s) (set_to_array (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9515_syn_1_iter_9515