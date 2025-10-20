import Mathlib

namespace no_76616_codeexercises_176616


-- Precondition definitions
@[reducible, simp]
def append_even_numbers_precond (num_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this simple function

-- Main function definitions
def append_even_numbers (num_list : List Nat) (h_precond : append_even_numbers_precond (num_list)) : List Nat :=
  -- !benchmark @start code
  let updated_list := num_list
  let range := List.range' 1 10 1
  List.foldl (fun acc i => if i % 2 = 0 then acc ++ [i] else acc) updated_list range
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def even_numbers_from_1_to_10 : List Nat := [2, 4, 6, 8, 10]

-- Postcondition definitions
@[reducible, simp]
def append_even_numbers_postcond (num_list : List Nat) (result: List Nat) (h_precond : append_even_numbers_precond (num_list)) : Prop :=
  -- !benchmark @start postcond
  result = num_list ++ even_numbers_from_1_to_10
  -- !benchmark @end postcond


-- Proof content
theorem append_even_numbers_postcond_satisfied (num_list: List Nat) (h_precond : append_even_numbers_precond (num_list)) :
    append_even_numbers_postcond (num_list) (append_even_numbers (num_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_76616_codeexercises_176616