import Mathlib

-- Precondition definitions
@[reducible, simp]
def digit_positions_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def digits_of_nat (num : Nat) : List Nat :=
  match num with
  | 0 => [0]
  | n+1 => 
    let rec loop (n : Nat) (acc : List Nat) : List Nat :=
      match n with
      | 0 => acc
      | m+1 => loop (m / 10) ((m % 10) :: acc)
    loop (n+1) []

def char_of_digit (d : Nat) : Char :=
  match d with
  | 0 => '0'
  | 1 => '1'
  | 2 => '2'
  | 3 => '3'
  | 4 => '4'
  | 5 => '5'
  | 6 => '6'
  | 7 => '7'
  | 8 => '8'
  | 9 => '9'
  | _ => '0' -- Should not happen for valid digits

-- Main function definitions
def digit_positions (n : Int) (h_precond : digit_positions_precond n) : List (Char × Nat) :=
  -- !benchmark @start code
  let abs_n := Int.natAbs n
  let digits := digits_of_nat abs_n
  let positions := List.range digits.length
  List.zip (List.map char_of_digit digits) (List.reverse positions)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def digits_of_nat_post (num : Nat) : List Nat :=
  match num with
  | 0 => [0]
  | n+1 => 
    let rec loop (n : Nat) (acc : List Nat) : List Nat :=
      match n with
      | 0 => acc
      | m+1 => loop (m / 10) ((m % 10) :: acc)
    loop (n+1) []

def char_of_digit_post (d : Nat) : Char :=
  match d with
  | 0 => '0'
  | 1 => '1'
  | 2 => '2'
  | 3 => '3'
  | 4 => '4'
  | 5 => '5'
  | 6 => '6'
  | 7 => '7'
  | 8 => '8'
  | 9 => '9'
  | _ => '0' -- Should not happen for valid digits

-- Postcondition definitions
@[reducible, simp]
def digit_positions_postcond (n : Int) (result: List (Char × Nat)) (h_precond : digit_positions_precond n) : Prop :=
  -- !benchmark @start postcond
  let abs_n := Int.natAbs n
  let digits := digits_of_nat_post abs_n
  let positions := List.range digits.length
  let expected := List.zip (List.map char_of_digit_post digits) (List.reverse positions)
  result = expected
  -- !benchmark @end postcond


-- Proof content
theorem digit_positions_postcond_satisfied (n: Int) (h_precond : digit_positions_precond n) :
    digit_positions_postcond n (digit_positions n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof