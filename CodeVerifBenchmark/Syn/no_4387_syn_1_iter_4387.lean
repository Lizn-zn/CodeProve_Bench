import Mathlib

namespace no_4387_syn_1_iter_4387


-- Precondition definitions
@[reducible, simp]
def process_strings_precond (lengths : Array Nat) (char_pairs : List (Char × Nat)) (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to check if a length is in the array
def length_in_array (lengths : Array Nat) (len : Nat) : Bool :=
  lengths.contains len

-- Helper function to get the first character of a string
def first_char (s : String) : Option Char :=
  match s.data with
  | [] => none
  | c :: _ => some c

-- Helper function to lookup a character in the character-natural pairs
def lookup_char_in_pairs (char_pairs : List (Char × Nat)) (c : Char) : Option Nat :=
  match char_pairs.find? (λ (pair : Char × Nat) => pair.1 = c) with
  | some (_, n) => some n
  | none => none

-- Main function definitions
def process_strings (lengths : Array Nat) (char_pairs : List (Char × Nat)) (strings : List String) (h_precond : process_strings_precond (lengths) (char_pairs) (strings)) : List Nat :=
  -- !benchmark @start code
  let result := strings.foldl (λ acc s =>
    -- Check if the string length is in the array
    if length_in_array lengths s.length then
      -- Get the first character of the string
      match first_char s with
      | some c =>
        -- Lookup the character in the character-natural pairs
        match lookup_char_in_pairs char_pairs c with
        | some n => n :: acc
        | none => acc  -- Skip if character not found
      | none => acc    -- Skip if string is empty
    else
      acc              -- Skip if length not in array
  ) []
  -- Reverse the result to maintain the original order
  result.reverse
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def lookup_char (char_pairs : List (Char × Nat)) (c : Char) : Option Nat :=
  match char_pairs.find? (λ (pair : Char × Nat) => pair.1 = c) with
  | some (_, n) => some n
  | none => none

def process_strings_expected (lengths : Array Nat) (char_pairs : List (Char × Nat)) (strings : List String) : List Nat :=
  strings.filterMap (λ s => 
    if lengths.contains s.length then
      match s.data with
      | [] => none
      | firstChar :: _ => lookup_char char_pairs firstChar
    else
      none
  )

-- Postcondition definitions
@[reducible, simp]
def process_strings_postcond (lengths : Array Nat) (char_pairs : List (Char × Nat)) (strings : List String) (result: List Nat) (h_precond : process_strings_precond (lengths) (char_pairs) (strings)) : Prop :=
  -- !benchmark @start postcond
  result = process_strings_expected lengths char_pairs strings
  -- !benchmark @end postcond


-- Proof content
theorem process_strings_postcond_satisfied (lengths: Array Nat) (char_pairs: List (Char × Nat)) (strings: List String) (h_precond : process_strings_precond (lengths) (char_pairs) (strings)) :
    process_strings_postcond (lengths) (char_pairs) (strings) (process_strings (lengths) (char_pairs) (strings) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4387_syn_1_iter_4387