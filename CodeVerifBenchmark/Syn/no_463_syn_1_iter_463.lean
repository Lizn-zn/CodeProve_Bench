import Mathlib

namespace no_463_syn_1_iter_463


-- Precondition definitions
@[reducible, simp]
def repeat_int_with_separators_precond (x : Int) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def repeat_int_with_separators_aux (x : Int) (n : Nat) : List Char :=
  match n with
  | 0 => []
  | 1 => (toString x).toList
  | n' + 1 =>
    let base := (toString x).toList
    let separator := [',', ' ']
    let rec build_list : Nat → List Char → List Char
      | 0, acc => acc
      | k + 1, acc => build_list k (base ++ separator ++ acc)
    build_list n' base

-- Main function definitions
def repeat_int_with_separators (x : Int) (n : Nat) (h_precond : repeat_int_with_separators_precond (x) (n)) : List Char :=
  -- !benchmark @start code
  match n with
  | 0 => []
  | 1 => (toString x).toList
  | n' + 1 =>
    let base := (toString x).toList
    let separator := [',', ' ']
    let rec build_list : Nat → List Char → List Char
      | 0, acc => acc
      | k + 1, acc => build_list k (base ++ separator ++ acc)
    build_list n' base
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def repeat_int_with_separators_expected (x : Int) (n : Nat) : List Char :=
  match n with
  | 0 => []
  | 1 => (toString x).toList
  | n' + 1 => 
    let base := (toString x).toList
    let separator := [',', ' ']
    let rec build_list : Nat → List Char → List Char
      | 0, acc => acc
      | k + 1, acc => build_list k (base ++ separator ++ acc)
    build_list n' base

-- Postcondition definitions
@[reducible, simp]
def repeat_int_with_separators_postcond (x : Int) (n : Nat) (result: List Char) (h_precond : repeat_int_with_separators_precond (x) (n)) : Prop :=
  -- !benchmark @start postcond
  result = repeat_int_with_separators_expected x n
  -- !benchmark @end postcond


-- Proof content
theorem repeat_int_with_separators_postcond_satisfied (x: Int) (n: Nat) (h_precond : repeat_int_with_separators_precond (x) (n)) :
    repeat_int_with_separators_postcond (x) (n) (repeat_int_with_separators (x) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_463_syn_1_iter_463