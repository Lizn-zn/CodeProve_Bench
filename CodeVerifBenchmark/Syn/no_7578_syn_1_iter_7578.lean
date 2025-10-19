import Mathlib

-- Precondition definitions
@[reducible, simp]
def pair_with_indices_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed

-- Main function definitions
def pair_with_indices (nums : List Nat) (h_precond : pair_with_indices_precond (nums)) : List (Nat × Nat) :=
  -- !benchmark @start code
  let rec go (idx : Nat) (nums : List Nat) : List (Nat × Nat) :=
    match nums with
    | [] => []
    | h :: t => (idx, h) :: go (idx + 1) t
  go 0 nums
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def enumerate (l : List Nat) : List (Nat × Nat) :=
  let rec go (idx : Nat) (l : List Nat) : List (Nat × Nat) :=
    match l with
    | [] => []
    | h :: t => (idx, h) :: go (idx + 1) t
  go 0 l

-- Postcondition definitions
@[reducible, simp]
def pair_with_indices_postcond (nums : List Nat) (result: List (Nat × Nat)) (h_precond : pair_with_indices_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  result = enumerate nums
  -- !benchmark @end postcond


-- Proof content
theorem pair_with_indices_postcond_satisfied (nums: List Nat) (h_precond : pair_with_indices_precond (nums)) :
    pair_with_indices_postcond (nums) (pair_with_indices (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

