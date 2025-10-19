import Mathlib

-- Precondition definitions
@[reducible, simp]
def count_rows_with_sum_in_list_precond (arr : Array (Array Int)) (sums_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def count_rows_with_sum_in_list (arr : Array (Array Int)) (sums_list : List Int) (h_precond : count_rows_with_sum_in_list_precond (arr) (sums_list)) : UInt8 :=
  -- !benchmark @start code
  let valid_rows := arr.filter (λ row => 
    let row_sum := row.foldl (λ acc x => acc + x) 0
    sums_list.contains row_sum)
  let count := valid_rows.size
  if count > 255 then
    255
  else
    count.toUInt8
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_rows_with_sum_in_list_post (arr : Array (Array Int)) (sums_list : List Int) : Nat :=
  let valid_rows := arr.filter (λ row => sums_list.contains (row.foldl (λ acc x => acc + x) 0))
  min valid_rows.size 255

-- Postcondition definitions
@[reducible, simp]
def count_rows_with_sum_in_list_postcond (arr : Array (Array Int)) (sums_list : List Int) (result: UInt8) (h_precond : count_rows_with_sum_in_list_precond (arr) (sums_list)) : Prop :=
  -- !benchmark @start postcond
  result = (count_rows_with_sum_in_list_post arr sums_list).toUInt8
  -- !benchmark @end postcond


-- Proof content
theorem count_rows_with_sum_in_list_postcond_satisfied (arr: Array (Array Int)) (sums_list: List Int) (h_precond : count_rows_with_sum_in_list_precond (arr) (sums_list)) :
    count_rows_with_sum_in_list_postcond (arr) (sums_list) (count_rows_with_sum_in_list (arr) (sums_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof