import Mathlib

-- Precondition definitions
@[reducible, simp]
def combine_and_append_precond (n : Nat) (a_list : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for the main code

-- Main function definitions
def combine_and_append (n : Nat) (a_list : List Nat) (h_precond : combine_and_append_precond (n) (a_list)) : List Nat :=
  -- !benchmark @start code
  let numbers := List.range (n + 1) |>.tail!
    let filtered := numbers.filter fun x => 
      let div3 := x % 3 == 0
      let div5 := x % 5 == 0
      (div3 || div5) && ¬(div3 && div5)
    a_list ++ filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_divisible_by_3_or_5_but_not_both (x : Nat) : Bool :=
  let div3 := x % 3 == 0
  let div5 := x % 5 == 0
  (div3 || div5) && ¬(div3 && div5)

def expected_numbers (n : Nat) : List Nat :=
  List.filter is_divisible_by_3_or_5_but_not_both (List.range (n + 1)).tail!

-- Postcondition definitions
@[reducible, simp]
def combine_and_append_postcond (n : Nat) (a_list : List Nat) (result: List Nat) (h_precond : combine_and_append_precond (n) (a_list)) : Prop :=
  -- !benchmark @start postcond
  result = a_list ++ expected_numbers n
  -- !benchmark @end postcond


-- Proof content
theorem combine_and_append_postcond_satisfied (n: Nat) (a_list: List Nat) (h_precond : combine_and_append_precond (n) (a_list)) :
    combine_and_append_postcond (n) (a_list) (combine_and_append (n) (a_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

