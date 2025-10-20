import Mathlib

namespace no_7471_syn_1_iter_7471


-- Precondition definitions
@[reducible, simp]
def find_char_occurrences_precond (n : Nat) (chars : List Char) (arr : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of a character in an array
def count_occurrences (arr : Array Char) (c : Char) : Nat :=
  arr.foldl (λ count x => if x = c then count + 1 else count) 0

-- Helper function to get the capped count (min of actual count and n)
def capped_count (arr : Array Char) (c : Char) (n : Nat) : Nat :=
  min (count_occurrences arr c) n

-- Helper function to find unique characters that appear in both chars and arr
def unique_chars_in_common (chars : List Char) (arr : Array Char) : List Char :=
  chars.dedup.filter (λ c => arr.contains c)

-- Main function definitions
def find_char_occurrences (n : Nat) (chars : List Char) (arr : Array Char) (h_precond : find_char_occurrences_precond n chars arr) : List (Nat × Nat) :=
  -- !benchmark @start code
  -- Get the unique characters that appear in both chars and arr
  let common_chars := unique_chars_in_common chars arr
  
  -- For each common character, create a pair (index_in_chars, capped_count)
  common_chars.map (λ c => 
    let idx := match chars.indexOf? c with
      | some i => i
      | none => 0  -- This case shouldn't happen due to filtering, but provides a default
    let count := capped_count arr c n
    (idx, count))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences_post (arr : Array Char) (c : Char) : Nat :=
  arr.foldl (λ count x => if x = c then count + 1 else count) 0

def capped_count_post (arr : Array Char) (c : Char) (n : Nat) : Nat :=
  min (count_occurrences_post arr c) n

def unique_chars_in_common_post (chars : List Char) (arr : Array Char) : List Char :=
  chars.dedup.filter (λ c => arr.contains c)

-- Postcondition definitions
@[reducible, simp]
def find_char_occurrences_postcond (n : Nat) (chars : List Char) (arr : Array Char) (result: List (Nat × Nat)) (h_precond : find_char_occurrences_precond n chars arr) : Prop :=
  -- !benchmark @start postcond
  let valid_chars := unique_chars_in_common_post chars arr
  let expected_pairs : List (Nat × Nat) := 
    valid_chars.map (λ c => 
      let idx := (chars.indexOf? c).getD 0
      let count := capped_count_post arr c n
      (idx, count))
  result = expected_pairs
  -- !benchmark @end postcond


-- Proof content
theorem find_char_occurrences_postcond_satisfied (n: Nat) (chars: List Char) (arr: Array Char) (h_precond : find_char_occurrences_precond n chars arr) :
    find_char_occurrences_postcond n chars arr (find_char_occurrences n chars arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_7471_syn_1_iter_7471