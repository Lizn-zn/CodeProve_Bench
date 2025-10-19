import Mathlib

-- Precondition definitions
@[reducible, simp]
def process_pairs_precond (pairs : List (Nat × Nat)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed beyond what's already provided in postcond_aux

-- Main function definitions
def process_pairs (pairs : List (Nat × Nat)) (h_precond : process_pairs_precond pairs) : (Int × Nat) × Array (Array Int) :=
  -- !benchmark @start code
  let total_sum := pairs.foldl (λ sum (a, _) => sum + (a : Int)) 0
  let max_first := match pairs with
    | [] => 0
    | (a, _) :: rest => rest.foldl (λ max_val (x, _) => max max_val x) a
  let array_result : Array (Array Int) := (pairs.map (λ (a, b) => #[(a : Int), (b : Int)])).toArray
  ((total_sum, max_first), array_result)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def sum_first_elements (pairs : List (Nat × Nat)) : Int :=
  pairs.foldl (λ sum (a, _) => sum + (a : Int)) 0

def max_first_element (pairs : List (Nat × Nat)) : Nat :=
  match pairs with
  | [] => 0
  | (a, _) :: rest => rest.foldl (λ max_val (x, _) => max max_val x) a

def pairs_to_2d_array (pairs : List (Nat × Nat)) : Array (Array Int) :=
  (pairs.map (λ (a, b) => #[(a : Int), (b : Int)])).toArray

-- Postcondition definitions
@[reducible, simp]
def process_pairs_postcond (pairs : List (Nat × Nat)) (result: (Int × Nat) × Array (Array Int)) (h_precond : process_pairs_precond pairs) : Prop :=
  -- !benchmark @start postcond
  let (total_sum, max_first) := result.1
  let array_result := result.2
  total_sum = sum_first_elements pairs ∧
  max_first = max_first_element pairs ∧
  array_result = pairs_to_2d_array pairs
  -- !benchmark @end postcond


-- Proof content
theorem process_pairs_postcond_satisfied (pairs: List (Nat × Nat)) (h_precond : process_pairs_precond pairs) :
    process_pairs_postcond pairs (process_pairs pairs h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof