import Mathlib

namespace no_230_syn_1_iter_230


-- Precondition definitions
@[reducible, simp]
def char_nat_pairs_to_ascii_product_set_precond (pairs : List (Char × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def compute_ascii_product (pair : Char × Nat) : Int :=
  (Char.toNat pair.fst : Int) * (pair.snd : Int)

def valid_products (pairs : List (Char × Nat)) : Set Int :=
  {x | ∃ (pair : Char × Nat) (h : pair ∈ pairs), x = compute_ascii_product pair ∧ x ≥ 0}

-- Main function definitions
def char_nat_pairs_to_ascii_product_set (pairs : List (Char × Nat)) (h_precond : char_nat_pairs_to_ascii_product_set_precond (pairs)) : Set Int :=
  -- !benchmark @start code
  let products := pairs.map compute_ascii_product
    let non_negative_products := products.filter (λ x => x ≥ 0)
    non_negative_products.toFinset
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def compute_ascii_product_post (pair : Char × Nat) : Int :=
  (Char.toNat pair.fst : Int) * (pair.snd : Int)

def valid_products_post (pairs : List (Char × Nat)) : Set Int :=
  {x | ∃ (pair : Char × Nat) (h : pair ∈ pairs), x = compute_ascii_product_post pair ∧ x ≥ 0}

-- Postcondition definitions
@[reducible, simp]
def char_nat_pairs_to_ascii_product_set_postcond (pairs : List (Char × Nat)) (result: Set Int) (h_precond : char_nat_pairs_to_ascii_product_set_precond (pairs)) : Prop :=
  -- !benchmark @start postcond
  result = valid_products_post pairs
  -- !benchmark @end postcond


-- Proof content
theorem char_nat_pairs_to_ascii_product_set_postcond_satisfied (pairs: List (Char × Nat)) (h_precond : char_nat_pairs_to_ascii_product_set_precond (pairs)) :
    char_nat_pairs_to_ascii_product_set_postcond (pairs) (char_nat_pairs_to_ascii_product_set (pairs) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_230_syn_1_iter_230