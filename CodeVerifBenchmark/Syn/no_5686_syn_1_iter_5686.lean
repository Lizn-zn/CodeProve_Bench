import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_pair_precond (x : Int) (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def even_numbers (n : Nat) : List Nat :=
  match n with
  | 0 => []
  | k + 1 => List.range n |>.map (λ i => 2 * i)

def int_to_char_list (x : Int) : List Char :=
  (toString x).data

-- Main function definitions
def process_pair (x : Int) (n : Nat) (h_precond : process_pair_precond (x) (n)) : List Char × List Nat :=
  -- !benchmark @start code
  (int_to_char_list x, even_numbers n)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def even_numbers_post (n : Nat) : List Nat :=
  match n with
  | 0 => []
  | k + 1 => List.range k |>.map (λ i => 2 * i)

def int_to_char_list_post (x : Int) : List Char :=
  (toString x).data

-- Postcondition definitions
@[reducible, simp]
def process_pair_postcond (x : Int) (n : Nat) (result: List Char × List Nat) (h_precond : process_pair_precond (x) (n)) : Prop :=
  -- !benchmark @start postcond
  result = (int_to_char_list_post x, even_numbers_post n)
  -- !benchmark @end postcond


-- Proof content
theorem process_pair_postcond_satisfied (x: Int) (n: Nat) (h_precond : process_pair_precond (x) (n)) :
    process_pair_postcond (x) (n) (process_pair (x) (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof