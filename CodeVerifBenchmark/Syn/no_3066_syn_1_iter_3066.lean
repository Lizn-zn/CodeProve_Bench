import Mathlib

namespace no_3066_syn_1_iter_3066


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def char_freq_with_ascii_precond (chars : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences (chars : List Char) (c : Char) : Nat :=
  (chars.filter (λ x => x = c)).length

def get_ascii_code (c : Char) : Nat :=
  c.toNat

def unique_chars (chars : List Char) : List Char :=
  chars.eraseDups

def sort_by_ascii (chars : List Char) : List Char :=
  chars.insertionSort (λ a b => get_ascii_code a ≤ get_ascii_code b)

-- Main function definitions
def char_freq_with_ascii (chars : List Char) (h_precond : char_freq_with_ascii_precond (chars)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let unique_sorted := sort_by_ascii (unique_chars chars)
  unique_sorted.map (λ c => (get_ascii_code c, count_occurrences chars c))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences_post (chars : List Char) (c : Char) : Nat :=
  (chars.filter (λ x => x = c)).length

def get_ascii_code_post (c : Char) : Nat :=
  c.toNat

def is_sorted_by_ascii (result : List (Nat × Nat)) : Prop :=
  ∀ i : Fin (result.length - 1), 
    (result.get ⟨i.val, by omega⟩).1 ≤ (result.get ⟨i.val + 1, by omega⟩).1

def has_correct_frequencies (chars : List Char) (result : List (Nat × Nat)) : Prop :=
  ∀ pair : Nat × Nat, 
    pair ∈ result → 
    ∃ c : Char, 
      get_ascii_code_post c = pair.1 ∧ 
      count_occurrences_post chars c = pair.2 ∧
      ∀ c' : Char, get_ascii_code_post c' = pair.1 → c' = c

def has_all_chars_represented (chars : List Char) (result : List (Nat × Nat)) : Prop :=
  ∀ c : Char, 
    c ∈ chars → 
    ∃ pair : Nat × Nat, 
      pair ∈ result ∧ 
      get_ascii_code_post c = pair.1 ∧ 
      count_occurrences_post chars c = pair.2

def no_duplicate_ascii_codes (result : List (Nat × Nat)) : Prop :=
  ∀ (i j : Fin result.length), 
    i ≠ j → 
    (result.get i).1 ≠ (result.get j).1

-- Postcondition definitions
@[reducible, simp]
def char_freq_with_ascii_postcond (chars : List Char) (result: List (Nat × Nat)) (h_precond : char_freq_with_ascii_precond (chars)) : Prop :=
  -- !benchmark @start postcond
  is_sorted_by_ascii result ∧
  has_correct_frequencies chars result ∧
  has_all_chars_represented chars result ∧
  no_duplicate_ascii_codes result
  -- !benchmark @end postcond


-- Proof content
theorem char_freq_with_ascii_postcond_satisfied (chars: List Char) (h_precond : char_freq_with_ascii_precond (chars)) :
    char_freq_with_ascii_postcond (chars) (char_freq_with_ascii (chars) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3066_syn_1_iter_3066