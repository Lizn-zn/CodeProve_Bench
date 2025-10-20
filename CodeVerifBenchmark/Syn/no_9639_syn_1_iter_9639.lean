import Mathlib

namespace no_9639_syn_1_iter_9639


-- Precondition definitions
@[reducible, simp]
def find_palindromic_substrings_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def is_palindrome_list (l : List Char) : Bool :=
  l = l.reverse

def extract_substring (s : String) (i j : Nat) : String :=
  s.extract ⟨i⟩ ⟨j + 1⟩

def is_palindrome_string (s : String) : Bool :=
  is_palindrome_list s.toList

def is_substring_palindrome_bool (s : String) (i j : Nat) : Bool :=
  if h : i ≤ j ∧ j < s.length then
    let substr := extract_substring s i j
    is_palindrome_string substr
  else
    false

def lex_order_bool (p1 p2 : Nat × Nat) : Bool :=
  p1.1 < p2.1 ∨ (p1.1 = p2.1 ∧ p1.2 ≤ p2.2)

def insertion_sort_lex (pairs : List (Nat × Nat)) : List (Nat × Nat) :=
  let rec insert (p : Nat × Nat) (l : List (Nat × Nat)) : List (Nat × Nat) :=
    match l with
    | [] => [p]
    | hd :: tl =>
      if lex_order_bool p hd then
        p :: hd :: tl
      else
        hd :: insert p tl
  let rec sort (l : List (Nat × Nat)) : List (Nat × Nat) :=
    match l with
    | [] => []
    | hd :: tl => insert hd (sort tl)
  sort pairs

-- Main function definitions
def find_palindromic_substrings (s : String) (h_precond : find_palindromic_substrings_precond (s)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let n := s.length
  let result := Id.run do
    let mut result : List (Nat × Nat) := []
    for i in [0:n] do
      for j in [i:n] do
        if is_substring_palindrome_bool s i j then
          result := result ++ [(i, j)]
    pure result
  insertion_sort_lex result
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_palindrome (s : String) : Prop :=
  s.toList = s.toList.reverse

def is_substring_palindrome (s : String) (i j : Nat) : Prop :=
  i ≤ j ∧ j < s.length ∧ is_palindrome (s.extract ⟨i⟩ ⟨j + 1⟩)

def lex_order (p1 p2 : Nat × Nat) : Prop :=
  p1.1 < p2.1 ∨ (p1.1 = p2.1 ∧ p1.2 ≤ p2.2)

def sorted_lex (pairs : List (Nat × Nat)) : Prop :=
  ∀ i j, i < j → j < pairs.length → lex_order (pairs.get! i) (pairs.get! j)

-- Postcondition definitions
@[reducible, simp]
def find_palindromic_substrings_postcond (s : String) (result: List (Nat × Nat)) (h_precond : find_palindromic_substrings_precond (s)) : Prop :=
  -- !benchmark @start postcond
  ∀ (i j : Nat), (i, j) ∈ result ↔ is_substring_palindrome s i j ∧
  sorted_lex result
  -- !benchmark @end postcond


-- Proof content
theorem find_palindromic_substrings_postcond_satisfied (s: String) (h_precond : find_palindromic_substrings_precond (s)) :
    find_palindromic_substrings_postcond (s) (find_palindromic_substrings (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_9639_syn_1_iter_9639