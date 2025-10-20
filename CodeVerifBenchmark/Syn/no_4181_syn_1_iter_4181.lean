import Mathlib

namespace no_4181_syn_1_iter_4181


-- Precondition definitions
@[reducible, simp]
def process_characters_precond (chars : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_alpha_code (c : Char) : Bool :=
  (c ≥ 'a' ∧ c ≤ 'z') ∨ (c ≥ 'A' ∧ c ≤ 'Z')

def split_alpha_sequences_code (chars : Array Char) : List (Array Char) :=
  let rec helper (i : Nat) (current : Array Char) (acc : List (Array Char)) : List (Array Char) :=
    if h : i < chars.size then
      let c := chars[i]!
      if is_alpha_code c then
        helper (i + 1) (current.push c) acc
      else
        helper (i + 1) #[] (if current.size > 0 then current :: acc else acc)
    else
      if current.size > 0 then current :: acc else acc
  List.reverse (helper 0 #[] [])

def get_non_alpha_chars_code (chars : Array Char) : String :=
  let rec helper (i : Nat) (acc : String) : String :=
    if h : i < chars.size then
      let c := chars[i]!
      if ¬ is_alpha_code c then
        helper (i + 1) (acc.push c)
      else
        helper (i + 1) acc
    else
      acc
  helper 0 ""

def char_to_ascii_array_code (arr : Array Char) : Array Nat :=
  arr.map (λ c => c.toNat)

-- Main function definitions
def process_characters (chars : Array Char) (h_precond : process_characters_precond (chars)) : (Array (Array Nat)) × String :=
  -- !benchmark @start code
  let word_arrays : Array (Array Nat) := (split_alpha_sequences_code chars).map char_to_ascii_array_code |>.toArray
  let non_alpha_str : String := get_non_alpha_chars_code chars
  (word_arrays, non_alpha_str)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_alpha_post (c : Char) : Bool :=
  (c ≥ 'a' ∧ c ≤ 'z') ∨ (c ≥ 'A' ∧ c ≤ 'Z')

def split_alpha_sequences_post (chars : Array Char) : List (Array Char) :=
  let rec helper (i : Nat) (current : Array Char) (acc : List (Array Char)) : List (Array Char) :=
    if h : i < chars.size then
      let c := chars[i]!
      if is_alpha_post c then
        helper (i + 1) (current.push c) acc
      else
        helper (i + 1) #[] (if current.size > 0 then current :: acc else acc)
    else
      if current.size > 0 then current :: acc else acc
  List.reverse (helper 0 #[] [])

def get_non_alpha_chars_post (chars : Array Char) : String :=
  let rec helper (i : Nat) (acc : String) : String :=
    if h : i < chars.size then
      let c := chars[i]!
      if ¬ is_alpha_post c then
        helper (i + 1) (acc.push c)
      else
        helper (i + 1) acc
    else
      acc
  helper 0 ""

def char_to_ascii_array_post (arr : Array Char) : Array Nat :=
  arr.map (λ c => c.toNat)

-- Postcondition definitions
@[reducible, simp]
def process_characters_postcond (chars : Array Char) (result: (Array (Array Nat)) × String) (h_precond : process_characters_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  let (word_arrays, non_alpha_str) := result
  let expected_word_arrays : Array (Array Nat) := 
    (split_alpha_sequences_post chars).map char_to_ascii_array_post |>.toArray
  let expected_non_alpha_str : String := get_non_alpha_chars_post chars
  word_arrays = expected_word_arrays ∧ non_alpha_str = expected_non_alpha_str
  -- !benchmark @end postcond


-- Proof content
theorem process_characters_postcond_satisfied (chars: Array Char) (h_precond : process_characters_precond (chars)) :
    process_characters_postcond (chars) (process_characters (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4181_syn_1_iter_4181