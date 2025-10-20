import Mathlib

namespace no_5072_syn_1_iter_5072


-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def generate_sum_sequences_precond (n : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate all sequences that sum to n, with each element being at most max_val
partial def generate_sum_sequences_aux (n : Nat) (max_val : Nat) : List (List Nat) :=
  if n = 0 then
    [[]]
  else
    let first_choices := List.range (min n max_val + 1)
    first_choices.flatMap λ first =>
      let remaining := n - first
      (generate_sum_sequences_aux remaining (min remaining max_val)).map λ tail =>
        first :: tail

-- Helper to generate all sequences with elements up to n
def generate_all_sum_sequences (n : Nat) : List (List Nat) :=
  generate_sum_sequences_aux n n

-- Main function definitions
def generate_sum_sequences (n : Nat) (h_precond : generate_sum_sequences_precond (n)) : List (List Nat) :=
  -- !benchmark @start code
  generate_all_sum_sequences n
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_sum_sequence (n : Nat) (seq : List Nat) : Prop :=
  seq.sum = n

def all_sum_sequences (n : Nat) : Set (List Nat) :=
  {seq | is_sum_sequence n seq}

-- Postcondition definitions
@[reducible, simp]
def generate_sum_sequences_postcond (n : Nat) (result: List (List Nat)) (h_precond : generate_sum_sequences_precond (n)) : Prop :=
  -- !benchmark @start postcond
  ∀ seq, seq ∈ result ↔ seq ∈ all_sum_sequences n
  -- !benchmark @end postcond


-- Proof content
theorem generate_sum_sequences_postcond_satisfied (n: Nat) (h_precond : generate_sum_sequences_precond (n)) :
    generate_sum_sequences_postcond (n) (generate_sum_sequences (n) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_5072_syn_1_iter_5072