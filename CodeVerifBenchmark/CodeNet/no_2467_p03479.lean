import Mathlib

namespace no_2467_p03479


-- Precondition definitions
@[reducible, simp]
def maxSequenceLength_precond (X : Nat) (Y : Nat) : Prop :=
  -- !benchmark @start precond
  1 ≤ X ∧ X ≤ Y
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute the maximum sequence length
partial def computeMaxLength (current : Nat) (limit : Nat) (count : Nat) : Nat :=
  if current > limit then
    count
  else
    computeMaxLength (current * 2) limit (count + 1)

-- Main function definitions
def maxSequenceLength (X : Nat) (Y : Nat) (h_precond : maxSequenceLength_precond (X) (Y)) : Nat :=
  -- !benchmark @start code
  computeMaxLength X Y 0
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- A valid sequence is one where each element is a multiple of the previous and strictly greater
def isValidSequence (seq : List Nat) (X Y : Nat) : Prop :=
  seq.length > 0 ∧
  (∀ i ∈ seq, X ≤ i ∧ i ≤ Y) ∧
  (∀ i : Fin (seq.length - 1), 
    let a := seq[i.val]!
    let b := seq[i.val + 1]!
    a < b ∧ ∃ k : Nat, k ≥ 2 ∧ b = k * a)

-- The result represents the maximum length of any valid sequence
def isMaxLength (X Y result : Nat) : Prop :=
  -- There exists a valid sequence of length `result`
  (∃ seq : List Nat, isValidSequence seq X Y ∧ seq.length = result) ∧
  -- No valid sequence has length greater than `result`
  (∀ seq : List Nat, isValidSequence seq X Y → seq.length ≤ result)

-- Postcondition definitions
@[reducible, simp]
def maxSequenceLength_postcond (X : Nat) (Y : Nat) (result: Nat) (h_precond : maxSequenceLength_precond (X) (Y)) : Prop :=
  -- !benchmark @start postcond
  isMaxLength X Y result
  -- !benchmark @end postcond


-- Proof content
theorem maxSequenceLength_postcond_satisfied (X: Nat) (Y: Nat) (h_precond : maxSequenceLength_precond (X) (Y)) :
    maxSequenceLength_postcond (X) (Y) (maxSequenceLength (X) (Y) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2467_p03479