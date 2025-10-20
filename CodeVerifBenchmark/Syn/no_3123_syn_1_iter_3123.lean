import Mathlib

namespace no_3123_syn_1_iter_3123


-- Precondition definitions
@[reducible, simp]
def extract_integers_precond (input : List (List String ⊕ List Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided

-- Main function definitions
def extract_integers (input : List (List String ⊕ List Int)) (h_precond : extract_integers_precond input) : List Int :=
  -- !benchmark @start code
  match input with
  | [] => []
  | (Sum.inl _) :: rest => extract_integers rest (by simp [extract_integers_precond])
  | (Sum.inr ints) :: rest => ints ++ extract_integers rest (by simp [extract_integers_precond])
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def extract_integers_aux : List (List String ⊕ List Int) → List Int
  | [] => []
  | (Sum.inl _) :: rest => extract_integers_aux rest
  | (Sum.inr ints) :: rest => ints ++ extract_integers_aux rest

-- Postcondition definitions
@[reducible, simp]
def extract_integers_postcond (input : List (List String ⊕ List Int)) (result: List Int) (h_precond : extract_integers_precond input) : Prop :=
  -- !benchmark @start postcond
  result = extract_integers_aux input
  -- !benchmark @end postcond


-- Proof content
theorem extract_integers_postcond_satisfied (input: List (List String ⊕ List Int)) (h_precond : extract_integers_precond input) :
    extract_integers_postcond input (extract_integers input h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_3123_syn_1_iter_3123