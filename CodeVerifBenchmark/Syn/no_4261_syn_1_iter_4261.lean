import Mathlib

namespace no_4261_syn_1_iter_4261


-- Precondition definitions
@[reducible, simp]
def filter_list_by_array_precond (input_list : List Int) (array : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def filter_list_by_array (input_list : List Int) (array : Array Int) (h_precond : filter_list_by_array_precond input_list array) : List Int :=
  -- !benchmark @start code
  let mem_fn := λ (x : Int) => array.contains x
  input_list.filter mem_fn
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def filter_list_by_array_mem (x : Int) (array : Array Int) : Prop :=
  ∃ (i : Fin array.size), array[i] = x

-- Postcondition definitions
@[reducible, simp]
def filter_list_by_array_postcond (input_list : List Int) (array : Array Int) (result: List Int) (h_precond : filter_list_by_array_precond input_list array) : Prop :=
  -- !benchmark @start postcond
  result = input_list.filter (λ x => array.contains x) ∧
  ∀ (x : Int), x ∈ result → x ∈ input_list ∧ filter_list_by_array_mem x array ∧
  ∀ (j : ℕ) (hj : j < result.length), 
    let idx_x := input_list.indexOf? x
    let idx_j := input_list.indexOf? (result.get ⟨j, hj⟩)
    idx_x.isSome ∧ idx_j.isSome ∧ idx_x.get! ≤ idx_j.get!
  -- !benchmark @end postcond


-- Proof content
theorem filter_list_by_array_postcond_satisfied (input_list: List Int) (array: Array Int) (h_precond : filter_list_by_array_precond input_list array) :
    filter_list_by_array_postcond input_list array (filter_list_by_array input_list array h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4261_syn_1_iter_4261