import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def compute_natural_numbers_precond (pairs : List (Char × Nat)) (pair_im : Int × Nat) (ch : Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def compute_natural_numbers (pairs : List (Char × Nat)) (pair_im : Int × Nat) (ch : Char) (h_precond : compute_natural_numbers_precond pairs pair_im ch) : Finset Nat :=
  -- !benchmark @start code
  let (i, m) := pair_im
  let candidates := pairs.filter (λ (c, n) => c = ch)
  let results := candidates.map (λ (c, n) =>
    match i with
    | Int.ofNat 0 => n
    | Int.negSucc _ => if n ≥ m then n - m else 0
    | Int.ofNat (k+1) => n + m)
  Finset.filter (λ k => k ≥ 0) (Finset.mk (results.dedup : Multiset Nat) (by simp [List.nodup_dedup]))
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- No auxiliary definitions needed for postcondition

-- Postcondition definitions
@[reducible, simp]
def compute_natural_numbers_postcond (pairs : List (Char × Nat)) (pair_im : Int × Nat) (ch : Char) (result: Finset Nat) (h_precond : compute_natural_numbers_precond pairs pair_im ch) : Prop :=
  -- !benchmark @start postcond
  let (i, m) := pair_im
  result = Finset.filter (λ k => k ≥ 0) 
    (Finset.image (λ (pair : Char × Nat) => 
      let (c, n) := pair
      if c = ch then
        match i with
        | Int.ofNat 0 => n
        | Int.negSucc _ => if n ≥ m then n - m else 0
        | Int.ofNat (k+1) => n + m
      else 0)
      (Finset.mk (pairs.dedup : Multiset (Char × Nat)) (by simp [List.nodup_dedup])))
  -- !benchmark @end postcond


-- Proof content
theorem compute_natural_numbers_postcond_satisfied (pairs: List (Char × Nat)) (pair_im: Int × Nat) (ch: Char) (h_precond : compute_natural_numbers_precond pairs pair_im ch) :
    compute_natural_numbers_postcond pairs pair_im ch (compute_natural_numbers pairs pair_im ch h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof