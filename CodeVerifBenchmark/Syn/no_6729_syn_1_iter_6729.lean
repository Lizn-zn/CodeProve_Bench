import Mathlib

namespace no_6729_syn_1_iter_6729


-- Precondition definitions
@[reducible, simp]
def count_frequencies_precond (arr : Array Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def insert_or_update (pairs : List (Int × Nat)) (x : Int) : List (Int × Nat) :=
  match pairs with
  | [] => [(x, 1)]
  | (y, count) :: rest =>
    if y = x then
      (y, count + 1) :: rest
    else
      (y, count) :: insert_or_update rest x

def count_frequencies_aux : List Int → List (Int × Nat) → List (Int × Nat)
  | [], acc => acc
  | x :: xs, acc => count_frequencies_aux xs (insert_or_update acc x)

-- Main function definitions
def count_frequencies (arr : Array Int) (h_precond : count_frequencies_precond (arr)) : List (Int × Nat) :=
  -- !benchmark @start code
  let arr_list := arr.toList
  count_frequencies_aux arr_list []
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences (arr : Array Int) (x : Int) : Nat :=
  (arr.filter (λ y => y = x)).size

def is_unique_list (pairs : List (Int × Nat)) : Prop :=
  ∀ (i j : Fin (pairs.length)) (h : i ≠ j), (pairs.get i).1 ≠ (pairs.get j).1

-- Postcondition definitions
@[reducible, simp]
def count_frequencies_postcond (arr : Array Int) (result: List (Int × Nat)) (h_precond : count_frequencies_precond (arr)) : Prop :=
  -- !benchmark @start postcond
  ∀ x, (x, count_occurrences arr x) ∈ result ∧
       ∀ (pair : Int × Nat), pair ∈ result → pair.2 = count_occurrences arr pair.1 ∧
       is_unique_list result
  -- !benchmark @end postcond


-- Proof content
theorem count_frequencies_postcond_satisfied (arr: Array Int) (h_precond : count_frequencies_precond (arr)) :
    count_frequencies_postcond (arr) (count_frequencies (arr) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6729_syn_1_iter_6729