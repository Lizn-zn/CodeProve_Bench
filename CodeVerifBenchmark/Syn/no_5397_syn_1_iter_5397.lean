import Mathlib

-- Precondition definitions
@[reducible, simp]
def find_min_diff_pair_precond (nums : List Float) : Prop :=
  -- !benchmark @start precond
  ∃ i j, i < j ∧ j < nums.length
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to compute all valid index pairs (i, j) with i < j < nums.length
def generate_pairs (nums : List Float) : List (Nat × Nat) :=
  let indices := List.range nums.length
  List.filter (λ (i, j) => i < j) (List.product indices indices)

-- Helper function to find the minimal pair according to the criteria
def find_min_pair (pairs : List (Nat × Nat)) (nums : List Float) : Nat × Nat :=
  match pairs with
  | [] => (0, 0) -- Should not happen due to precondition
  | (i, j) :: rest =>
    let min_diff := Float.abs (nums.get! i - nums.get! j)
    let rec find_min (current_min : Nat × Nat) (current_diff : Float) (remaining : List (Nat × Nat)) : Nat × Nat :=
      match remaining with
      | [] => current_min
      | (k, l) :: tail =>
        let diff := Float.abs (nums.get! k - nums.get! l)
        if diff < current_diff then
          find_min (k, l) diff tail
        else if diff == current_diff then
          -- Same difference, choose lexicographically smallest (i, j)
          if k < current_min.1 then
            find_min (k, l) current_diff tail
          else if k == current_min.1 ∧ l < current_min.2 then
            find_min (k, l) current_diff tail
          else
            find_min current_min current_diff tail
        else
          find_min current_min current_diff tail
    find_min (i, j) min_diff rest

-- Main function definitions
def find_min_diff_pair (nums : List Float) (h_precond : find_min_diff_pair_precond (nums)) : Nat × Nat :=
  -- !benchmark @start code
  -- Generate all valid index pairs where i < j
  let pairs := generate_pairs nums
  
  -- Find the pair with minimal absolute difference
  find_min_pair pairs nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_min_diff_pair (nums : List Float) (i j : Nat) : Prop :=
  i < j ∧ j < nums.length ∧
  (∀ k l, k < l → l < nums.length → 
    Float.abs (nums.get! k - nums.get! l) ≥ Float.abs (nums.get! i - nums.get! j)) ∧
  (∀ k l, k < l → l < nums.length → 
    Float.abs (nums.get! k - nums.get! l) = Float.abs (nums.get! i - nums.get! j) → 
    (k > i ∨ (k = i ∧ l ≥ j)))

-- Postcondition definitions
@[reducible, simp]
def find_min_diff_pair_postcond (nums : List Float) (result: Nat × Nat) (h_precond : find_min_diff_pair_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let (i, j) := result
  is_min_diff_pair nums i j
  -- !benchmark @end postcond


-- Proof content
theorem find_min_diff_pair_postcond_satisfied (nums: List Float) (h_precond : find_min_diff_pair_precond (nums)) :
    find_min_diff_pair_postcond nums (find_min_diff_pair nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof