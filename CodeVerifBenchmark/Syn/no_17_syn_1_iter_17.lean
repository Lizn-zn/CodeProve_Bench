import Mathlib

namespace no_17_syn_1_iter_17


-- Precondition definitions
@[reducible, simp]
def construct_array_precond (int_arr : Array Int) (nat_arr : Array Nat) (nat_pair : Nat × Nat) (int_pairs : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def construct_array (int_arr : Array Int) (nat_arr : Array Nat) (nat_pair : Nat × Nat) (int_pairs : List (Int × Int)) (h_precond : construct_array_precond (int_arr) (nat_arr) (nat_pair) (int_pairs)) : Array Int :=
  -- !benchmark @start code
  match int_pairs with
  | [] => int_arr
  | (first, _) :: _ => 
    let sum : Nat := nat_pair.1 + nat_pair.2
    let result : Int := first * (sum : Int)
    int_arr.push result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def process_int_pairs (int_arr : Array Int) (nat_pair : Nat × Nat) (int_pairs : List (Int × Int)) : Array Int :=
  match int_pairs with
  | [] => int_arr
  | (first, _) :: _ => 
    let sum := nat_pair.1 + nat_pair.2
    let result := first * (sum : Int)
    int_arr.push result

-- Postcondition definitions
@[reducible, simp]
def construct_array_postcond (int_arr : Array Int) (nat_arr : Array Nat) (nat_pair : Nat × Nat) (int_pairs : List (Int × Int)) (result: Array Int) (h_precond : construct_array_precond (int_arr) (nat_arr) (nat_pair) (int_pairs)) : Prop :=
  -- !benchmark @start postcond
  result = process_int_pairs int_arr nat_pair int_pairs
  -- !benchmark @end postcond


-- Proof content
theorem construct_array_postcond_satisfied (int_arr: Array Int) (nat_arr: Array Nat) (nat_pair: Nat × Nat) (int_pairs: List (Int × Int)) (h_precond : construct_array_precond (int_arr) (nat_arr) (nat_pair) (int_pairs)) :
    construct_array_postcond (int_arr) (nat_arr) (nat_pair) (int_pairs) (construct_array (int_arr) (nat_arr) (nat_pair) (int_pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_17_syn_1_iter_17