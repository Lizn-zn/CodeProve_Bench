import Mathlib

namespace no_414_syn_1_iter_414


-- Precondition definitions
@[reducible, simp]
def nat_to_string_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def digits : List Char := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

def digit_of_nat (d : Nat) : Char :=
  if h : d < 10 then
    have h2 : d < digits.length := by
      simp [digits]
      omega
    digits.get ⟨d, h2⟩
  else
    '0'

def string_of_nat_aux : Nat → List Char → List Char
  | 0, acc => acc
  | n+1, acc => 
    let digit := digit_of_nat ((n+1) % 10)
    let quotient := (n+1) / 10
    string_of_nat_aux quotient (digit :: acc)

def expected_string (n : Nat) : String :=
  match n with
  | 0 => "0"
  | _ => 
    let chars := string_of_nat_aux n []
    String.mk chars

-- Main function definitions
def nat_to_string (n : Nat) (h_precond : nat_to_string_precond (n)) : String :=
  -- !benchmark @start code
  match n with
  | 0 => "0"
  | _ => 
    let chars := string_of_nat_aux n []
    String.mk chars
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def digits_post : List Char := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

def digit_of_nat_post (d : Nat) : Char :=
  if h : d < 10 then
    have h2 : d < digits_post.length := by
      simp [digits_post]
      omega
    digits_post.get ⟨d, h2⟩
  else
    '0'

def string_of_nat_aux_post : Nat → List Char → List Char
  | 0, acc => acc
  | n+1, acc => 
    let digit := digit_of_nat_post ((n+1) % 10)
    let quotient := (n+1) / 10
    string_of_nat_aux_post quotient (digit :: acc)

def expected_string_post (n : Nat) : String :=
  match n with
  | 0 => "0"
  | _ => 
    let chars := string_of_nat_aux_post n []
    String.mk chars

-- Postcondition definitions
@[reducible, simp]
def nat_to_string_postcond (n : Nat) (result: String) (h_precond : nat_to_string_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = expected_string_post n
  -- !benchmark @end postcond


-- Proof content
theorem nat_to_string_postcond_satisfied (n: Nat) (h_precond : nat_to_string_precond (n)) :
    nat_to_string_postcond (n) (nat_to_string (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_414_syn_1_iter_414