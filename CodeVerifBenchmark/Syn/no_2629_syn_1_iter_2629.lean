import Mathlib.Data.List.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Data.Nat.Basic

namespace no_2629_syn_1_iter_2629


-- Precondition definitions
@[reducible, simp]
def process_char_array_and_pairs_precond (arr : Array Char) (lst : List (Int × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided in postcond_aux

-- Main function definitions
def process_char_array_and_pairs (arr : Array Char) (lst : List (Int × Nat)) (h_precond : process_char_array_and_pairs_precond (arr) (lst)) : Int × List (Nat × Nat) :=
  -- !benchmark @start code
  let positive_sum := lst.filter (λ (p : Int × Nat) => p.1 > 0) |>.foldl (λ acc p => acc + p.1) 0
  let negative_pairs := lst.filter (λ (p : Int × Nat) => p.1 < 0)
  let second_components := negative_pairs.map Prod.snd
  let count_list : List (Nat × Nat) :=
    second_components.foldl (λ (counts : List (Nat × Nat)) n => 
      match counts.find? (λ (k, _) => k == n) with
      | some (k, count) => (counts.filter (λ (k', _) => k' ≠ n)).cons (n, count + 1)
      | none => (n, 1) :: counts) []
  (positive_sum, count_list)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_positive_first_components (lst : List (Int × Nat)) : Int :=
  (lst.filter (λ p => p.1 > 0)).foldl (λ acc p => acc + p.1) 0

def count_occurrences_of_second_components (lst : List (Int × Nat)) : List (Nat × Nat) :=
  let negative_pairs := lst.filter (λ p => p.1 < 0)
  let second_components := negative_pairs.map Prod.snd
  second_components.foldl (λ (counts : List (Nat × Nat)) n => 
    match counts.find? (λ (k, _) => k == n) with
    | some (k, count) => (counts.filter (λ (k', _) => k' ≠ n)).cons (n, count + 1)
    | none => (n, 1) :: counts) []

-- Postcondition definitions
@[reducible, simp]
def process_char_array_and_pairs_postcond (arr : Array Char) (lst : List (Int × Nat)) (result: Int × List (Nat × Nat)) (h_precond : process_char_array_and_pairs_precond (arr) (lst)) : Prop :=
  -- !benchmark @start postcond
  let (sum_result, count_list) := result
  sum_result = sum_positive_first_components lst ∧
  count_list = count_occurrences_of_second_components lst
  -- !benchmark @end postcond


-- Proof content
theorem process_char_array_and_pairs_postcond_satisfied (arr: Array Char) (lst: List (Int × Nat)) (h_precond : process_char_array_and_pairs_precond (arr) (lst)) :
    process_char_array_and_pairs_postcond (arr) (lst) (process_char_array_and_pairs (arr) (lst) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2629_syn_1_iter_2629