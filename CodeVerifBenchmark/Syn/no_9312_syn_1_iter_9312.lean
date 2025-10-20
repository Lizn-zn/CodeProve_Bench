import Mathlib

namespace no_9312_syn_1_iter_9312


-- Precondition auxiliary definitions
/-- Auxiliary function to compute the sum of elements in an integer array -/
def sum_array (arr : Array Int) : Int :=
  arr.foldl (λ acc x => acc + x) 0

/-- Auxiliary function to get the character at a given index with modulo wrapping -/
def get_char_with_mod (char_array : Array Char) (idx : Nat) : Char :=
  if h : char_array.size > 0 then
    have : idx % char_array.size < char_array.size := Nat.mod_lt _ (by omega)
    char_array[idx % char_array.size]'this
  else
    default

/-- Convert an integer to a character with ASCII range wrapping (0-127) -/
def int_to_ascii_char (n : Int) : Char :=
  let wrapped := (n % 128).toNat
  Char.ofNat (wrapped % 128)

-- Precondition definitions
@[reducible, simp]
def compute_char_array_precond (int_array : Array (Array Int)) (char_array : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
/-- Helper function to process a single row and compute the resulting character -/
def process_row (char_array : Array Char) (idx : Nat) (row : Array Int) : Char :=
  let row_sum := sum_array row
  let base_char := get_char_with_mod char_array idx
  let base_code := base_char.toNat
  let total_code := base_code + row_sum
  int_to_ascii_char total_code

-- Main function definitions
def compute_char_array (int_array : Array (Array Int)) (char_array : Array Char) (h_precond : compute_char_array_precond (int_array) (char_array)) : Array Char :=
  -- !benchmark @start code
  Id.run do
    let mut result := Array.mkEmpty int_array.size
    for i in [0:int_array.size] do
      let row := int_array[i]!
      let char := process_row char_array i row
      result := result.push char
    result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
/-- Auxiliary function to compute the expected result character for a given row -/
def compute_expected_char (row : Array Int) (char_array : Array Char) (char_idx : Nat) : Char :=
  let row_sum := sum_array row
  let base_char := get_char_with_mod char_array char_idx
  let base_code := base_char.toNat
  let total_code := base_code + row_sum
  int_to_ascii_char total_code

-- Postcondition definitions
@[reducible, simp]
def compute_char_array_postcond (int_array : Array (Array Int)) (char_array : Array Char) (result: Array Char) (h_precond : compute_char_array_precond (int_array) (char_array)) : Prop :=
  -- !benchmark @start postcond
  result.size = int_array.size ∧
  ∀ (i : Nat) (h : i < result.size),
    result[i] = compute_expected_char int_array[i]! char_array i
  -- !benchmark @end postcond


-- Proof content
theorem compute_char_array_postcond_satisfied (int_array: Array (Array Int)) (char_array: Array Char) (h_precond : compute_char_array_precond (int_array) (char_array)) :
    compute_char_array_postcond (int_array) (char_array) (compute_char_array (int_array) (char_array) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9312_syn_1_iter_9312