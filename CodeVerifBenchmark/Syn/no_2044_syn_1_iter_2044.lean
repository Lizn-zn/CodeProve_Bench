import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_even_sum_pairs_precond (n : UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No additional auxiliary definitions needed beyond what's provided in postcond_aux

-- Main function definitions
def generate_even_sum_pairs (n : UInt8) (h_precond : generate_even_sum_pairs_precond (n)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let n_nat := n.toNat
  let pairs := List.range (n_nat + 1) |>.flatMap λ a => 
    List.range (n_nat + 1) |>.map λ b => (a, b)
  pairs.filter λ p => ((p.1 + p.2) % 2 == 0)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_even_sum (p : Nat × Nat) : Bool :=
  ((p.1 + p.2) % 2 == 0)

def all_pairs_up_to (n : Nat) : List (Nat × Nat) :=
  (List.range (n + 1)).flatMap (λ a => (List.range (n + 1)).map (λ b => (a, b)))

def lex_sorted_pairs (n : Nat) : List (Nat × Nat) :=
  all_pairs_up_to n |>.filter is_even_sum

-- Postcondition definitions
@[reducible, simp]
def generate_even_sum_pairs_postcond (n : UInt8) (result: List (Nat × Nat)) (h_precond : generate_even_sum_pairs_precond (n)) : Prop :=
  -- !benchmark @start postcond
  result = lex_sorted_pairs (n.toNat)
  -- !benchmark @end postcond


-- Proof content
theorem generate_even_sum_pairs_postcond_satisfied (n: UInt8) (h_precond : generate_even_sum_pairs_precond (n)) :
    generate_even_sum_pairs_postcond (n) (generate_even_sum_pairs (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof