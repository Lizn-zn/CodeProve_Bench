import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_lex_pairs_precond (a : Nat) (b : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def generate_lex_pairs (a : Nat) (b : Nat) (h_precond : generate_lex_pairs_precond a b) : List (Nat × Nat) :=
  -- !benchmark @start code
  List.ofFn fun i : Fin ((a + 1) * (b + 1)) => 
    (i.val / (b + 1), i.val % (b + 1))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_lex_sorted (pairs : List (Nat × Nat)) : Prop :=
  ∀ i j : Fin (pairs.length), i < j → 
    let (x₁, y₁) := pairs.get i
    let (x₂, y₂) := pairs.get j
    x₁ < x₂ ∨ (x₁ = x₂ ∧ y₁ ≤ y₂)

-- Postcondition definitions
@[reducible, simp]
def generate_lex_pairs_postcond (a : Nat) (b : Nat) (result: List (Nat × Nat)) (h_precond : generate_lex_pairs_precond a b) : Prop :=
  -- !benchmark @start postcond
  result.length = (a + 1) * (b + 1) ∧
  (∀ (x y : Nat), (x, y) ∈ result ↔ x ≤ a ∧ y ≤ b) ∧
  is_lex_sorted result ∧
  ∀ (p : Nat × Nat), p ∈ result → p.1 ≤ a ∧ p.2 ≤ b
  -- !benchmark @end postcond


-- Proof content
theorem generate_lex_pairs_correct (a b : Nat) (h_precond : generate_lex_pairs_precond a b) : 
    generate_lex_pairs_postcond a b (generate_lex_pairs a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof