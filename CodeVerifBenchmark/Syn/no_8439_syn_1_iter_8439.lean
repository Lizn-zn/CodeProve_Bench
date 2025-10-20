import Mathlib

namespace no_8439_syn_1_iter_8439


-- Precondition definitions
@[reducible, simp]
def generate_repeated_string_precond (a : Nat) (b : Nat) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def generate_repeated_string (a : Nat) (b : Nat) (n : Nat) (h_precond : generate_repeated_string_precond (a) (b) (n)) : Array Char :=
  -- !benchmark @start code
  let base_string := s!"a = {a}, b = {b}; "
    let base_array := base_string.toList.toArray
    let rec build_result (count : Nat) (acc : Array Char) : Array Char :=
      match count with
      | 0 => acc
      | k+1 => build_result k (acc ++ base_array)
    build_result n #[]
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def expected_string (a : Nat) (b : Nat) : String :=
  s!"a = {a}, b = {b}; "

def expected_array (a : Nat) (b : Nat) : Array Char :=
  (expected_string a b).toList.toArray

def expected_result (a : Nat) (b : Nat) (n : Nat) : Array Char :=
  match n with
  | 0 => #[]
  | n+1 => expected_result a b n ++ expected_array a b

-- Postcondition definitions
@[reducible, simp]
def generate_repeated_string_postcond (a : Nat) (b : Nat) (n : Nat) (result: Array Char) (h_precond : generate_repeated_string_precond (a) (b) (n)) : Prop :=
  -- !benchmark @start postcond
  result = expected_result a b n
  -- !benchmark @end postcond


-- Proof content
theorem generate_repeated_string_postcond_satisfied (a: Nat) (b: Nat) (n: Nat) (h_precond : generate_repeated_string_precond (a) (b) (n)) :
    generate_repeated_string_postcond (a) (b) (n) (generate_repeated_string (a) (b) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8439_syn_1_iter_8439