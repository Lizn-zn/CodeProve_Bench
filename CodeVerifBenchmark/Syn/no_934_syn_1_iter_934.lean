import Mathlib

namespace no_934_syn_1_iter_934


-- Precondition definitions
@[reducible, simp]
def count_and_sum_pairs_precond (xs : List Int) (pairs : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to count occurrences of x as first element in pairs
def count_occurrences (x : Int) (pairs : List (Int × Int)) : Nat :=
  (pairs.filter (λ p => p.1 = x)).length

-- Helper function to sum second components where first equals x
def sum_second_components (x : Int) (pairs : List (Int × Int)) : Nat :=
  pairs.foldl (λ acc p => if p.1 = x then acc + p.2.toNat else acc) 0

-- Main function definitions
def count_and_sum_pairs (xs : List Int) (pairs : List (Int × Int)) (h_precond : count_and_sum_pairs_precond xs pairs) : List (Int × Nat) × Array Nat :=
  -- !benchmark @start code
  -- Create the list of (element, count) pairs
  let count_list : List (Int × Nat) := xs.map (λ x => (x, count_occurrences x pairs))
  
  -- Create the array of sums
  let sum_array : Array Nat := 
    xs.enum.foldl (λ arr (i, x) => arr.set! i (sum_second_components x pairs)) (Array.mkArray xs.length 0)
  
  -- Return the pair
  (count_list, sum_array)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences_post (x : Int) (pairs : List (Int × Int)) : Nat :=
  (pairs.filter (λ p => p.1 = x)).length

def sum_second_components_post (x : Int) (pairs : List (Int × Int)) : Nat :=
  pairs.foldl (λ acc p => if p.1 = x then acc + p.2.toNat else acc) 0

-- Postcondition definitions
@[reducible, simp]
def count_and_sum_pairs_postcond (xs : List Int) (pairs : List (Int × Int)) (result: List (Int × Nat) × Array Nat) (h_precond : count_and_sum_pairs_precond xs pairs) : Prop :=
  -- !benchmark @start postcond
  let (count_list, sum_array) := result
  count_list = xs.map (λ x => (x, count_occurrences_post x pairs)) ∧
  sum_array.size = xs.length ∧
  ∀ (i : Nat), i < xs.length → 
    sum_array[i]! = sum_second_components_post (xs.get! i) pairs
  -- !benchmark @end postcond


-- Proof content
theorem count_and_sum_pairs_postcond_satisfied (xs: List Int) (pairs: List (Int × Int)) (h_precond : count_and_sum_pairs_precond xs pairs) :
    count_and_sum_pairs_postcond xs pairs (count_and_sum_pairs xs pairs h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_934_syn_1_iter_934