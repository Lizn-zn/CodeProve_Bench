import Mathlib

-- Precondition definitions
@[reducible, simp]
def palindrome_substrings_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_palindrome_check (s : String) : Bool :=
  s.toList = s.toList.reverse

def get_substring_check (s : String) (start_idx end_idx : Nat) : String :=
  s.extract ⟨start_idx⟩ ⟨end_idx + 1⟩

def is_palindromic_substring_check (s : String) (start_idx end_idx : Nat) : Bool :=
  if h : start_idx ≤ end_idx ∧ end_idx < s.length then
    let substr := get_substring_check s start_idx end_idx
    is_palindrome_check substr
  else
    false

def insert_sorted (pair : Nat × Nat) (pairs : List (Nat × Nat)) : List (Nat × Nat) :=
  match pairs with
  | [] => [pair]
  | (s', e') :: rest =>
    let (s, e) := pair
    if s < s' then
      pair :: (s', e') :: rest
    else if s = s' then
      if e ≤ e' then
        pair :: (s', e') :: rest
      else
        (s', e') :: insert_sorted pair rest
    else
      (s', e') :: insert_sorted pair rest

def generate_pairs (s : String) : List (Nat × Nat) :=
  let n := s.length
  let rec outer (i : Nat) (acc : List (Nat × Nat)) : List (Nat × Nat) :=
    if h : i < n then
      let rec inner (j : Nat) (acc' : List (Nat × Nat)) : List (Nat × Nat) :=
        if h' : j < n then
          if i ≤ j then
            if is_palindromic_substring_check s i j then
              inner (j + 1) (insert_sorted (i, j) acc')
            else
              inner (j + 1) acc'
          else
            inner (j + 1) acc'
        else
          acc'
      outer (i + 1) (inner i acc)
    else
      acc
  outer 0 []

-- Main function definitions
def palindrome_substrings (s : String) (h_precond : palindrome_substrings_precond (s)) : List (Nat × Nat) :=
  -- !benchmark @start code
  generate_pairs s
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_palindrome (s : String) : Prop :=
  s.toList = s.toList.reverse

def is_contiguous_substring (s : String) (start_idx end_idx : Nat) : Prop :=
  start_idx ≤ end_idx ∧ end_idx < s.length

def get_substring (s : String) (start_idx end_idx : Nat) : String :=
  s.extract ⟨start_idx⟩ ⟨end_idx + 1⟩

def is_palindromic_substring (s : String) (start_idx end_idx : Nat) : Prop :=
  is_contiguous_substring s start_idx end_idx ∧ is_palindrome (get_substring s start_idx end_idx)

def sorted_by_start_then_end (pairs : List (Nat × Nat)) : Prop :=
  ∀ i j : Fin pairs.length, i.val < j.val → 
    let (s1, e1) := pairs.get i
    let (s2, e2) := pairs.get j
    s1 < s2 ∨ (s1 = s2 ∧ e1 ≤ e2)

-- Postcondition definitions
@[reducible, simp]
def palindrome_substrings_postcond (s : String) (result: List (Nat × Nat)) (h_precond : palindrome_substrings_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let valid_pairs : Set (Nat × Nat) := 
    { p | ∃ (start_idx end_idx : Nat), p = (start_idx, end_idx) ∧ is_palindromic_substring s start_idx end_idx }
  (result.toFinset : Set (Nat × Nat)) = valid_pairs ∧ sorted_by_start_then_end result
  -- !benchmark @end postcond


-- Proof content
theorem palindrome_substrings_postcond_satisfied (s: String) (h_precond : palindrome_substrings_precond (s)) :
    palindrome_substrings_postcond s (palindrome_substrings s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof