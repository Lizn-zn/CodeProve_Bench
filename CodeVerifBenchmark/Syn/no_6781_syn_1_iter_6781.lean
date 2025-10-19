import Mathlib

-- Precondition definitions
@[reducible, simp]
def extract_positive_naturals_precond (pairs : List (Int × Nat)) (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def extract_positive_naturals (pairs : List (Int × Nat)) (s : String) (h_precond : extract_positive_naturals_precond (pairs) (s)) : Finset Nat :=
  -- !benchmark @start code
  let positive_pairs := pairs.filter (λ p => p.1 > 0)
  let nats := positive_pairs.map Prod.snd
  have h : nats.dedup.Nodup := by simp [List.nodup_dedup]
  Finset.mk (nats.dedup) h
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def extract_positive_naturals_postcond (pairs : List (Int × Nat)) (s : String) (result: Finset Nat) (h_precond : extract_positive_naturals_precond (pairs) (s)) : Prop :=
  -- !benchmark @start postcond
  have h : (pairs.map Prod.snd).dedup.Nodup := by simp [List.nodup_dedup]
  result = Finset.filter (λ n => ∃ (pair : Int × Nat), pair ∈ pairs ∧ pair.1 > 0 ∧ pair.2 = n) (Finset.mk (pairs.map Prod.snd).dedup h)
  -- !benchmark @end postcond


-- Proof content
theorem extract_positive_naturals_postcond_satisfied (pairs: List (Int × Nat)) (s: String) (h_precond : extract_positive_naturals_precond (pairs) (s)) :
    extract_positive_naturals_postcond (pairs) (s) (extract_positive_naturals (pairs) (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof