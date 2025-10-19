import Mathlib

-- Precondition auxiliary definitions
structure MinHeap (α : Type) where
  contains : α → Bool

-- Precondition definitions
@[reducible, simp]
def compute_relevant_integers_precond (char_nat_pairs : List (Char × Nat)) (min_heap : MinHeap Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Postcondition auxiliary definitions
def relevant_nats (char_nat_pairs : List (Char × Nat)) (min_heap : MinHeap Char) : Set Nat :=
  { n | ∃ (c : Char) (h : min_heap.contains c = true), (c, n) ∈ char_nat_pairs }

-- Postcondition definitions
@[reducible, simp]
def compute_relevant_integers_postcond (char_nat_pairs : List (Char × Nat)) (min_heap : MinHeap Char) (result: Set Int) (h_precond : compute_relevant_integers_precond (char_nat_pairs) (min_heap)) : Prop :=
  -- !benchmark @start postcond
  result = { Int.ofNat n | n ∈ relevant_nats char_nat_pairs min_heap }
  -- !benchmark @end postcond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def compute_relevant_integers (char_nat_pairs : List (Char × Nat)) (min_heap : MinHeap Char) (h_precond : compute_relevant_integers_precond (char_nat_pairs) (min_heap)) : Set Int :=
  -- !benchmark @start code
  let relevant_nats := relevant_nats char_nat_pairs min_heap
  { x | ∃ (n : Nat), n ∈ relevant_nats ∧ x = Int.ofNat n }
  -- !benchmark @end code


-- Proof content
theorem compute_relevant_integers_postcond_satisfied (char_nat_pairs: List (Char × Nat)) (min_heap: MinHeap Char) (h_precond : compute_relevant_integers_precond (char_nat_pairs) (min_heap)) :
    compute_relevant_integers_postcond (char_nat_pairs) (min_heap) (compute_relevant_integers (char_nat_pairs) (min_heap) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof