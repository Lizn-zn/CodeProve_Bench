import Mathlib

namespace no_7013_syn_1_iter_7013


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def process_floats_and_char_precond (floats : List Float) (char : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def compute_total_sum (floats : List Float) : Float :=
  floats.foldl (λ sum f => sum + f) 0.0

def compute_integer_parts (floats : List Float) : List Nat :=
  floats.map (λ f => (Float.floor (Float.abs f)).toUInt64.toNat)

def build_char_array (counts : List Nat) (char : Char) : Array Char :=
  counts.foldl (λ arr count => arr ++ (Array.mk (List.replicate count char))) (Array.empty : Array Char)

-- Main function definitions
def process_floats_and_char (floats : List Float) (char : Char) (h_precond : process_floats_and_char_precond (floats) (char)) : Nat × Array Char :=
  -- !benchmark @start code
  let total_sum := compute_total_sum floats
    let sum_int := (Float.floor total_sum).toUInt64.toNat
    let integer_parts := compute_integer_parts floats
    let char_array := build_char_array integer_parts char
    (sum_int, char_array)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def compute_total_chars (floats : List Float) : Nat :=
  floats.foldl (λ sum f => sum + (Float.floor (Float.abs f)).toUInt64.toNat) 0

def generate_char_array (floats : List Float) (char : Char) : Array Char :=
  floats.foldl (λ arr f => 
    let count := (Float.floor (Float.abs f)).toUInt64.toNat
    arr ++ (Array.mk (List.replicate count char))
  ) (Array.empty : Array Char)

-- Postcondition definitions
@[reducible, simp]
def process_floats_and_char_postcond (floats : List Float) (char : Char) (result: Nat × Array Char) (h_precond : process_floats_and_char_precond (floats) (char)) : Prop :=
  -- !benchmark @start postcond
  let (sum_int, char_array) := result
  let total_sum := floats.foldl (λ sum f => sum + f) 0.0
  let expected_sum_int := Float.floor total_sum |>.toUInt64.toNat
  let expected_char_array := generate_char_array floats char
  sum_int = expected_sum_int ∧ char_array = expected_char_array
  -- !benchmark @end postcond


-- Proof content
theorem process_floats_and_char_postcond_satisfied (floats: List Float) (char: Char) (h_precond : process_floats_and_char_precond (floats) (char)) :
    process_floats_and_char_postcond (floats) (char) (process_floats_and_char (floats) (char) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7013_syn_1_iter_7013