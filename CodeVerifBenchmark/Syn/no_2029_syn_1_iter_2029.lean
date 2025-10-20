import Mathlib

namespace no_2029_syn_1_iter_2029


-- Precondition definitions
@[reducible, simp]
def find_indices_above_threshold_precond (arr : Array (Array Int)) (threshold : UInt8) : Prop :=
  -- !benchmark @start precond
  ∀ (i : Nat), i < arr.size → ∀ (j : Nat), j < (arr.get! i).size → True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Helper function to process a single row
def process_row (row : Array Int) (row_idx : Nat) (threshold : Int) : List (Nat × Nat) :=
  let indices := List.range row.size
  indices.filterMap (λ col_idx => 
    if row.get! col_idx > threshold then some (row_idx, col_idx) else none)

-- Helper function to process all rows
def process_all_rows (arr : Array (Array Int)) (threshold : Int) : List (Nat × Nat) :=
  let row_indices := List.range arr.size
  row_indices.flatMap (λ row_idx => 
    process_row (arr.get! row_idx) row_idx threshold)

-- Main function definitions
def find_indices_above_threshold (arr : Array (Array Int)) (threshold : UInt8) (h_precond : find_indices_above_threshold_precond (arr) (threshold)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let threshold_int : Int := threshold.toNat
  process_all_rows arr threshold_int
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def is_row_major_sorted (indices : List (Nat × Nat)) : Prop :=
  ∀ (k : Nat), k < indices.length - 1 → 
    let (r1, c1) := indices.get! k
    let (r2, c2) := indices.get! (k + 1)
    r1 < r2 ∨ (r1 = r2 ∧ c1 < c2)

-- Postcondition definitions
@[reducible, simp]
def find_indices_above_threshold_postcond (arr : Array (Array Int)) (threshold : UInt8) (result: List (Nat × Nat)) (h_precond : find_indices_above_threshold_precond (arr) (threshold)) : Prop :=
  -- !benchmark @start postcond
  let threshold_int : Int := threshold.toNat
  let all_indices : List (Nat × Nat) := 
    (List.range arr.size).flatMap (λ i => 
      (List.range (arr.get! i).size).map (λ j => (i, j)))
  let expected_indices : List (Nat × Nat) :=
    all_indices.filter (λ (i, j) => (arr.get! i).get! j > threshold_int)
  result = expected_indices ∧ is_row_major_sorted result
  -- !benchmark @end postcond


-- Proof content
theorem find_indices_above_threshold_postcond_satisfied (arr: Array (Array Int)) (threshold: UInt8) (h_precond : find_indices_above_threshold_precond (arr) (threshold)) :
    find_indices_above_threshold_postcond (arr) (threshold) (find_indices_above_threshold (arr) (threshold) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2029_syn_1_iter_2029