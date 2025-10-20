import Mathlib

namespace no_294_syn_1_iter_294


-- Precondition definitions
@[reducible, simp]
def count_positives_precond (nums : List Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_positives_aux (nums : List Float) : Nat :=
  nums.filter (λ x => x > 0.0) |>.length

-- Main function definitions
def count_positives (nums : List Float) (h_precond : count_positives_precond (nums)) : UInt8 :=
  -- !benchmark @start code
  let count := nums.filter (λ x => x > 0.0) |>.length
  if h : count < UInt8.size then
    ⟨count, h⟩
  else
    ⟨0, by simp [UInt8.size]⟩
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_positives_post_aux (nums : List Float) : Nat :=
  nums.filter (λ x => x > 0.0) |>.length

-- Postcondition definitions
@[reducible, simp]
def count_positives_postcond (nums : List Float) (result: UInt8) (h_precond : count_positives_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result.toNat = count_positives_post_aux nums ∧ result.toNat < UInt8.size
  -- !benchmark @end postcond


-- Proof content
theorem count_positives_postcond_satisfied (nums: List Float) (h_precond : count_positives_precond (nums)) :
    count_positives_postcond (nums) (count_positives (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_294_syn_1_iter_294