import Mathlib

-- Precondition definitions
@[reducible, simp]
def convert_to_binary_precond (number : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to convert a natural number to a binary string -/
def to_binary_aux : Nat → List Char
  | 0 => ['0']
  | 1 => ['1']
  | n + 2 => 
    have : (n + 2) / 2 < n + 2 := by
      omega
    to_binary_aux ((n + 2) / 2) ++ [if (n + 2) % 2 = 0 then '0' else '1']

-- Main function definitions
def convert_to_binary (number : Nat) (h_precond : convert_to_binary_precond (number)) : String :=
  -- !benchmark @start code
  match number with
  | 0 => "0"
  | _ => 
    let rec aux (n : Nat) : List Char :=
      match n with
      | 0 => []
      | n + 1 => 
        have : (n + 1) / 2 < n + 1 := by
          omega
        aux ((n + 1) / 2) ++ [if (n + 1) % 2 = 0 then '0' else '1']
    String.mk (aux number)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def binary_digits : List Char := ['0', '1']

def is_binary_string (s : String) : Prop :=
  ∀ (c : Char), c ∈ s.data → c ∈ binary_digits

def string_to_nat_binary (s : String) : Nat :=
  s.foldl (λ acc c => acc * 2 + (if c = '1' then 1 else 0)) 0

-- Postcondition definitions
@[reducible, simp]
def convert_to_binary_postcond (number : Nat) (result: String) (h_precond : convert_to_binary_precond (number)) : Prop :=
  -- !benchmark @start postcond
  is_binary_string result ∧ string_to_nat_binary result = number
  -- !benchmark @end postcond


-- Proof content
theorem convert_to_binary_postcond_satisfied (number: Nat) (h_precond : convert_to_binary_precond (number)) :
    convert_to_binary_postcond (number) (convert_to_binary (number) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

