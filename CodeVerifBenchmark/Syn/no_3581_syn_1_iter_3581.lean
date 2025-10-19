import Mathlib

-- Precondition definitions
@[reducible, simp]
def generate_sum_pairs_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def abs_nat (n : Int) : Nat :=
  match n with
  | Int.ofNat k => k
  | Int.negSucc k => k + 1

-- Main function definitions
def generate_sum_pairs (n : Int) (h_precond : generate_sum_pairs_precond n) : List (Nat × Nat) :=
  -- !benchmark @start code
  let abs_val := abs_nat n
  (List.range (abs_val + 1)).map (λ i => (i, abs_val - i))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
theorem abs_nat_nonneg (n : Int) : 0 ≤ abs_nat n := by
  unfold abs_nat
  match n with
  | Int.ofNat _ => simp
  | Int.negSucc _ => simp

theorem abs_nat_eq_abs (n : Int) : (abs_nat n : Int) = Int.natAbs n := by
  unfold abs_nat
  match n with
  | Int.ofNat k => simp [Int.natAbs]
  | Int.negSucc k => simp [Int.natAbs]

-- Postcondition definitions
@[reducible, simp]
def generate_sum_pairs_postcond (n : Int) (result: List (Nat × Nat)) (h_precond : generate_sum_pairs_precond n) : Prop :=
  -- !benchmark @start postcond
  let abs_val := abs_nat n
  result = (List.range (abs_val + 1)).map (λ i => (i, abs_val - i)) ∧
  ∀ (p : Nat × Nat), p ∈ result → p.1 + p.2 = abs_val
  -- !benchmark @end postcond


-- Proof content
theorem generate_sum_pairs_postcond_satisfied (n: Int) (h_precond : generate_sum_pairs_precond n) :
    generate_sum_pairs_postcond n (generate_sum_pairs n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof