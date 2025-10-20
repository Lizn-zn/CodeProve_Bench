import Mathlib

namespace no_6136_syn_1_iter_6136


-- Precondition definitions
@[reducible, simp]
def find_common_elements_precond (nat_set : Finset ℕ) (int_set : Finset ℤ) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def find_common_elements (nat_set : Finset ℕ) (int_set : Finset ℤ) (h_precond : find_common_elements_precond nat_set int_set) : Array ℤ :=
  -- !benchmark @start code
  let common_nats : Finset ℤ := nat_set.map (Function.Embedding.mk (λ n : ℕ => (n : ℤ)) (by
    intro x y h
    simp at h
    exact h))
  let common_set : Finset ℤ := common_nats ∩ int_set
  let sorted_list : List ℤ := common_set.sort (λ a b => a ≤ b)
  sorted_list.toArray
  -- !benchmark @end code


-- Postcondition definitions
@[reducible, simp]
def find_common_elements_postcond (nat_set : Finset ℕ) (int_set : Finset ℤ) (result: Array ℤ) (h_precond : find_common_elements_precond nat_set int_set) : Prop :=
  -- !benchmark @start postcond
  let common_set : Finset ℤ := (nat_set.map (Function.Embedding.mk (λ n : ℕ => (n : ℤ)) (by
    intro x y h
    simp at h
    exact h))).filter (λ x => x ∈ int_set)
  let expected_list : List ℤ := common_set.sort (λ a b => a ≤ b)
  result.toList = expected_list ∧ result.toList.Sorted (λ a b => a ≤ b) ∧ result.toList.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem find_common_elements_postcond_satisfied (nat_set: Finset ℕ) (int_set: Finset ℤ) (h_precond : find_common_elements_precond nat_set int_set) :
    find_common_elements_postcond nat_set int_set (find_common_elements nat_set int_set h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6136_syn_1_iter_6136