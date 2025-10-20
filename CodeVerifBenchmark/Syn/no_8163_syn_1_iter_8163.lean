import Mathlib

namespace no_8163_syn_1_iter_8163


-- Precondition definitions
@[reducible, simp]
def generate_ordered_pairs_precond (s : Finset Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to generate all ordered pairs from a Finset
noncomputable def generate_ordered_pairs_aux (s : Finset Nat) : List (Nat × Nat) :=
  let elements := s.toList
  List.flatMap (λ a => 
    elements.filter (λ b => a < b) |>.map (λ b => (a, b))) elements

-- Main function definitions
noncomputable def generate_ordered_pairs (s : Finset Nat) (h_precond : generate_ordered_pairs_precond (s)) : List (Nat × Nat) :=
  -- !benchmark @start code
  -- Convert the Finset to a sorted list to ensure consistent ordering
  let sorted_list := s.sort (λ x y => x ≤ y)
  
  -- Generate all pairs (a, b) where a < b and both are in s
  let pairs := List.flatMap (λ ⟨i, a⟩ => 
    sorted_list.drop (i + 1) |>.map (λ b => (a, b))) sorted_list.enum
  
  -- The result is already nodup due to our construction method
  pairs
  -- !benchmark @end code


-- Postcondition auxiliary definitions
noncomputable def all_ordered_pairs (s : Finset Nat) : Finset (Nat × Nat) :=
  s.filter (λ a => (s.filter (λ b => a < b)).Nonempty) |>.biUnion 
    (λ a => (s.filter (λ b => a < b)).image 
      (λ b => (a, b)))

-- Postcondition definitions
@[reducible, simp]
def generate_ordered_pairs_postcond (s : Finset Nat) (result: List (Nat × Nat)) (h_precond : generate_ordered_pairs_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let expected_pairs : Finset (Nat × Nat) := all_ordered_pairs s
  (result.toFinset : Finset (Nat × Nat)) = expected_pairs ∧ 
  result.Nodup
  -- !benchmark @end postcond


-- Proof content
theorem generate_ordered_pairs_postcond_satisfied (s: Finset Nat) (h_precond : generate_ordered_pairs_precond (s)) :
    generate_ordered_pairs_postcond (s) (generate_ordered_pairs (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_8163_syn_1_iter_8163