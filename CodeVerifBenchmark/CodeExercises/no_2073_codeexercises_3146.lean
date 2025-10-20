import Mathlib

namespace no_2073_codeexercises_3146


-- Precondition definitions
@[reducible, simp]
def break_out_loop_xor_precond (lst1 : List Int) (lst2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if two integers have different parity
def have_different_parity (x y : Int) : Bool :=
  ((x % 2 == 0) && (y % 2 != 0)) || ((x % 2 != 0) && (y % 2 == 0))

-- Helper function to compute the sum of elements up to a given index
def sum_up_to (lst : List Int) (idx : Nat) : Int :=
  match lst, idx with
  | _, 0 => 0
  | [], _ => 0
  | h::t, n+1 => h + sum_up_to t n

-- Main function definitions
def break_out_loop_xor (lst1 : List Int) (lst2 : List Int) (h_precond : break_out_loop_xor_precond (lst1) (lst2)) : Int :=
  -- !benchmark @start code
  let rec loop (lst1 lst2 : List Int) (sum : Int) : Int :=
    match lst1, lst2 with
    | [], _ => -1
    | _, [] => -1
    | x::xs, y::ys =>
      if have_different_parity x y then
        sum + x + y
      else
        loop xs ys (sum + x + y)
  loop lst1 lst2 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def find_parity_diff_index (lst1 : List Int) (lst2 : List Int) : Option Nat :=
  let rec find (pairs : List (Int × Int)) (idx : Nat) : Option Nat :=
    match pairs with
    | [] => none
    | (x, y) :: rest =>
      if have_different_parity x y then
        some idx
      else
        find rest (idx + 1)
  find (List.zip lst1 lst2) 0

def sum_up_to_index (lst1 : List Int) (lst2 : List Int) (idx : Nat) : Int :=
  let sum1 := (lst1.take idx).foldl (· + ·) 0
  let sum2 := (lst2.take idx).foldl (· + ·) 0
  sum1 + sum2

-- Postcondition definitions
@[reducible, simp]
def break_out_loop_xor_postcond (lst1 : List Int) (lst2 : List Int) (result: Int) (h_precond : break_out_loop_xor_precond (lst1) (lst2)) : Prop :=
  -- !benchmark @start postcond
  match find_parity_diff_index lst1 lst2 with
  | some idx => result = sum_up_to_index lst1 lst2 idx
  | none => result = -1
  -- !benchmark @end postcond


-- Proof content
theorem break_out_loop_xor_postcond_satisfied (lst1: List Int) (lst2: List Int) (h_precond : break_out_loop_xor_precond (lst1) (lst2)) :
    break_out_loop_xor_postcond (lst1) (lst2) (break_out_loop_xor (lst1) (lst2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2073_codeexercises_3146