import Mathlib

namespace no_4976_syn_1_iter_4976


-- Precondition definitions
@[reducible, simp]
def extract_integers_precond (input : Array Char ⊕ List Char ⊕ (Int × Nat) ⊕ Array Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Postcondition auxiliary definitions (moved before main function)
def range_from_start_count (start : Int) (count : Nat) : Set Int :=
  match count with
  | 0 => {start}
  | n + 1 => (Finset.range (n + 1)).image (λ k : Nat => start + (k : Int))

def chars_to_ascii_set (chars : List Char) : Set Int :=
  chars.map (λ c => (c.toNat : Int)) |>.toFinset |>.toSet

def array_chars_to_ascii_set (arr : Array Char) : Set Int :=
  arr.toList.map (λ c => (c.toNat : Int)) |>.toFinset |>.toSet

def array_nat_to_int_set (arr : Array Nat) : Set Int :=
  arr.toList.map (λ n => (n : Int)) |>.toFinset |>.toSet

-- Main function definitions
def extract_integers (input : Array Char ⊕ List Char ⊕ (Int × Nat) ⊕ Array Nat) (h_precond : extract_integers_precond (input)) : Set Int :=
  -- !benchmark @start code
  match input with
  | .inl arr => array_chars_to_ascii_set arr
  | .inr (.inl lst) => chars_to_ascii_set lst
  | .inr (.inr (.inl (i, n))) => range_from_start_count i n
  | .inr (.inr (.inr arr)) => array_nat_to_int_set arr
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def extract_integers_postcond (input : Array Char ⊕ List Char ⊕ (Int × Nat) ⊕ Array Nat) (result: Set Int) (h_precond : extract_integers_precond (input)) : Prop :=
  -- !benchmark @start postcond
  match input with
  | .inl arr => result = array_chars_to_ascii_set arr
  | .inr (.inl lst) => result = chars_to_ascii_set lst
  | .inr (.inr (.inl (i, n))) => result = range_from_start_count i n
  | .inr (.inr (.inr arr)) => result = array_nat_to_int_set arr
  -- !benchmark @end postcond


-- Proof content
theorem extract_integers_postcond_satisfied (input: Array Char ⊕ List Char ⊕ (Int × Nat) ⊕ Array Nat) (h_precond : extract_integers_precond (input)) :
    extract_integers_postcond (input) (extract_integers (input) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_4976_syn_1_iter_4976