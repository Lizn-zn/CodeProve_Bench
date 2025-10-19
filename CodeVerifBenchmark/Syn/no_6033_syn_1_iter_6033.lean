import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_ascii_pairs_and_array_precond (n : Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def compute_ascii_char (n : Int) (i : Nat) : Char :=
  let ascii_val := ((n + (i : Int)) % 128).toNat % 128
  Char.ofNat ascii_val

def generate_pairs (n : Int) (k : Nat) : List (Prod Char Nat) :=
  List.range k |>.map (λ i => (compute_ascii_char n i, i))

def take_first_chars (pairs : List (Prod Char Nat)) (k : Nat) : Array Char :=
  Array.mk ((pairs.map Prod.fst).take (min k 5))

-- Main function definitions
def generate_ascii_pairs_and_array (n : Int) (k : Nat) (h_precond : generate_ascii_pairs_and_array_precond n k) : Prod (List (Prod Char Nat)) (Array Char) :=
  -- !benchmark @start code
  let pairs := generate_pairs n k
  let arr := take_first_chars pairs k
  (pairs, arr)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def valid_ascii_char (c : Char) : Prop :=
  let val := c.toNat
  val < 128

def compute_ascii_char_post (n : Int) (i : Nat) : Char :=
  let ascii_val := ((n + (i : Int)) % 128).toNat % 128
  Char.ofNat ascii_val

def expected_pairs (n : Int) (k : Nat) : List (Prod Char Nat) :=
  List.range k |>.map (λ i => (compute_ascii_char_post n i, i))

def expected_array (n : Int) (k : Nat) : Array Char :=
  let chars := expected_pairs n k |>.map Prod.fst
  Array.mk (chars.take (min k 5))

-- Postcondition definitions
@[reducible, simp]
def generate_ascii_pairs_and_array_postcond (n : Int) (k : Nat) (result: Prod (List (Prod Char Nat)) (Array Char)) (h_precond : generate_ascii_pairs_and_array_precond n k) : Prop :=
  -- !benchmark @start postcond
  let (pairs, arr) := result
  pairs = expected_pairs n k ∧
  arr = expected_array n k ∧
  ∀ (c : Char), c ∈ pairs.map Prod.fst → valid_ascii_char c
  -- !benchmark @end postcond


-- Proof content
theorem generate_ascii_pairs_and_array_postcond_satisfied (n: Int) (k: Nat) (h_precond : generate_ascii_pairs_and_array_precond n k) :
    generate_ascii_pairs_and_array_postcond n k (generate_ascii_pairs_and_array n k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof