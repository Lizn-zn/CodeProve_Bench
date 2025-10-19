import Mathlib

-- Precondition definitions
@[reducible, simp]
def replace_chars_at_indices_precond (arr : Array Char) (c : Char) (indices : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def filter_valid_indices (arr : Array Char) (indices : List Int) : List Nat :=
  indices.filterMap λ idx => 
    if idx ≥ 0 then
      let n := idx.toNat
      if n < arr.size then some n else none
    else none

def count_distinct_valid (valid_indices : List Nat) : Nat :=
  (valid_indices.eraseDup).length

def replace_at_valid_indices (arr : Array Char) (c : Char) (valid_indices : List Nat) : Array Char :=
  let valid_set : Set Nat := {i | valid_indices.contains i}
  arr.mapIdx λ i char => if valid_indices.contains i then c else char

-- Main function definitions
def replace_chars_at_indices (arr : Array Char) (c : Char) (indices : List Int) (h_precond : replace_chars_at_indices_precond (arr) (c) (indices)) : Array Char × Int :=
  -- !benchmark @start code
  let valid_indices_list := filter_valid_indices arr indices
  let count := count_distinct_valid valid_indices_list
  let result_arr := replace_at_valid_indices arr c valid_indices_list
  (result_arr, count)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def valid_indices (arr : Array Char) (indices : List Int) : Set Nat :=
  { i | ∃ (n : Nat) (h : n < arr.size), (indices.contains (Int.ofNat n)) ∧ i = n }

def count_valid_indices (arr : Array Char) (indices : List Int) : Nat :=
  let valid_set : Finset Nat := Finset.filter (λ i => i < arr.size ∧ indices.contains (Int.ofNat i)) (Finset.range arr.size)
  Finset.card valid_set

def replace_at_indices (arr : Array Char) (c : Char) (indices : List Int) : Array Char :=
  let valid_set : Finset Nat := Finset.filter (λ i => i < arr.size ∧ indices.contains (Int.ofNat i)) (Finset.range arr.size)
  arr.mapIdx (λ i char => if i ∈ valid_set then c else char)

-- Postcondition definitions
@[reducible, simp]
def replace_chars_at_indices_postcond (arr : Array Char) (c : Char) (indices : List Int) (result: Array Char × Int) (h_precond : replace_chars_at_indices_precond (arr) (c) (indices)) : Prop :=
  -- !benchmark @start postcond
  let (result_arr, count) := result
  result_arr = replace_at_indices arr c indices ∧ 
  count = count_valid_indices arr indices ∧
  result_arr.size = arr.size
  -- !benchmark @end postcond


-- Proof content
theorem replace_chars_at_indices_postcond_satisfied (arr: Array Char) (c: Char) (indices: List Int) (h_precond : replace_chars_at_indices_precond (arr) (c) (indices)) :
    replace_chars_at_indices_postcond (arr) (c) (indices) (replace_chars_at_indices (arr) (c) (indices) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof