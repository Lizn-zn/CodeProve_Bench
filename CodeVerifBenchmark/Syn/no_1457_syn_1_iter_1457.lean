import Mathlib

namespace no_1457_syn_1_iter_1457


-- Precondition definitions
@[reducible, simp]
def find_consecutive_sequences_precond (arr : Array Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- Postcondition auxiliary definitions
def is_consecutive_sequence (arr : Array Char) (start : Nat) (length : Nat) : Prop :=
  start + length ≤ arr.size ∧
  (∀ i : Nat, i < length → arr[start + i]! = arr[start]!) ∧
  (start > 0 → arr[start - 1]! ≠ arr[start]!) ∧
  (start + length < arr.size → arr[start + length]! ≠ arr[start]!)

def covers_all_characters (arr : Array Char) (result : List (Nat × Nat)) : Prop :=
  if arr.size = 0 then
    result = []
  else
    let total_length := result.foldl (fun sum (start, len) => sum + len) 0
    total_length = arr.size ∧
    (∀ (start len : Nat), (start, len) ∈ result → is_consecutive_sequence arr start len) ∧
    (∀ i : Nat, i < arr.size → ∃ (start len : Nat), (start, len) ∈ result ∧ start ≤ i ∧ i < start + len) ∧
    (∀ (s1 l1 s2 l2 : Nat), (s1, l1) ∈ result → (s2, l2) ∈ result → s1 ≠ s2 → s1 + l1 ≤ s2 ∨ s2 + l2 ≤ s1)

def is_maximal_sequence (arr : Array Char) (result : List (Nat × Nat)) : Prop :=
  ∀ (start len : Nat), (start, len) ∈ result → 
    ¬∃ (start' len' : Nat), start' ≤ start ∧ start + len ≤ start' + len' ∧ 
                          is_consecutive_sequence arr start' len' ∧ (start', len') ∉ result

-- Postcondition definitions
@[reducible, simp]
def find_consecutive_sequences_postcond (arr : Array Char) (result: List (Nat × Nat)) (h_precond : find_consecutive_sequences_precond arr) : Prop :=
  -- !benchmark @start postcond
  covers_all_characters arr result ∧ is_maximal_sequence arr result
  -- !benchmark @end postcond

-- Main function definitions
def find_consecutive_sequences (arr : Array Char) (h_precond : find_consecutive_sequences_precond arr) : List (Nat × Nat) :=
  -- !benchmark @start code
  if h : arr.size = 0 then
    []
  else
    let rec loop (i : Nat) (current_start : Nat) (current_len : Nat) (acc : List (Nat × Nat)) : List (Nat × Nat) :=
      if h_i : i < arr.size then
        if h_prev : i > 0 then
          if arr[i]! = arr[i - 1]! then
            loop (i + 1) current_start (current_len + 1) acc
          else
            loop (i + 1) i 1 ((current_start, current_len) :: acc)
        else
          loop (i + 1) current_start (current_len + 1) acc
      else
        (current_start, current_len) :: acc
    let result := loop 1 0 1 []
    result.reverse
  -- !benchmark @end code

-- Proof content
theorem find_consecutive_sequences_postcond_satisfied (arr: Array Char) (h_precond : find_consecutive_sequences_precond arr) :
    find_consecutive_sequences_postcond arr (find_consecutive_sequences arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_1457_syn_1_iter_1457