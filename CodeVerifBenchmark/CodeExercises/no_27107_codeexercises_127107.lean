import Mathlib

-- Precondition definitions
@[reducible, simp]
def exiting_while_loops_and_appending_elements_to_a_list_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def exiting_while_loops_and_appending_elements_to_a_list (n : Nat) (h_precond : exiting_while_loops_and_appending_elements_to_a_list_precond (n)) : List Nat :=
  -- !benchmark @start code
  let rec loop (current_sum : Nat) (current_list : List Nat) : List Nat :=
    if current_sum ≥ n then
      current_list
    else
      -- Append the next natural number to the list
      let next_num := current_list.length
      loop (current_sum + next_num) (current_list ++ [next_num])
  termination_by n - current_sum
  decreasing_by sorry
  loop 0 []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_ge_n (n : Nat) (result : List Nat) : Prop :=
  result.sum ≥ n

-- Postcondition definitions
@[reducible, simp]
def exiting_while_loops_and_appending_elements_to_a_list_postcond (n : Nat) (result: List Nat) (h_precond : exiting_while_loops_and_appending_elements_to_a_list_precond (n)) : Prop :=
  -- !benchmark @start postcond
  sum_ge_n n result
  -- !benchmark @end postcond


-- Proof content
theorem exiting_while_loops_and_appending_elements_to_a_list_postcond_satisfied (n: Nat) (h_precond : exiting_while_loops_and_appending_elements_to_a_list_precond (n)) :
    exiting_while_loops_and_appending_elements_to_a_list_postcond (n) (exiting_while_loops_and_appending_elements_to_a_list (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof