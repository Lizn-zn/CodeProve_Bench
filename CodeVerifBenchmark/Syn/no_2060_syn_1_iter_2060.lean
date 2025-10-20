import Mathlib

namespace no_2060_syn_1_iter_2060

-- Precondition auxiliary definitions
structure MinHeap (α : Type) [Inhabited α] [LE α] where
  elems : List α
  is_min_heap : ∀ i j, i < j → j < elems.length → elems[i]! ≤ elems[j]!

-- Precondition definitions
@[reducible, simp]
def get_frequent_values_precond (heap : MinHeap Nat) (k : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def count_occurrences (nums : List Nat) (target : Nat) : Nat :=
  nums.foldl (λ count n => if n = target then count + 1 else count) 0

def get_frequencies (nums : List Nat) : List (Nat × Nat) :=
  let unique_vals := nums.eraseDups
  unique_vals.map (λ val => (val, count_occurrences nums val))

def is_sorted_by_value (pairs : List (Nat × Nat)) : Prop :=
  ∀ i j, i < j → j < pairs.length → (pairs[i]!.1 ≤ pairs[j]!.1)

-- Main function definitions
def get_frequent_values (heap : MinHeap Nat) (k : Nat) (h_precond : get_frequent_values_precond heap k) : List (Nat × Nat) :=
  -- !benchmark @start code
  let frequencies := get_frequencies heap.elems
  let filtered := frequencies.filter (λ (_, count) => count ≥ k)
  filtered
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def count_occurrences_post (nums : List Nat) (target : Nat) : Nat :=
  nums.foldl (λ count n => if n = target then count + 1 else count) 0

def is_sorted_by_value_post (pairs : List (Nat × Nat)) : Prop :=
  ∀ i j, i < j → j < pairs.length → (pairs[i]!.1 ≤ pairs[j]!.1)

def get_frequencies_post (nums : List Nat) : List (Nat × Nat) :=
  let unique_vals := nums.eraseDups
  unique_vals.map (λ val => (val, count_occurrences_post nums val))

-- Postcondition definitions
@[reducible, simp]
def get_frequent_values_postcond (heap : MinHeap Nat) (k : Nat) (result : List (Nat × Nat)) (h_precond : get_frequent_values_precond heap k) : Prop :=
  -- !benchmark @start postcond
  let frequencies := get_frequencies_post heap.elems
  let filtered := frequencies.filter (λ (_, count) => count ≥ k)
  is_sorted_by_value_post filtered ∧
  result = filtered
  -- !benchmark @end postcond


-- Proof content
theorem get_frequent_values_postcond_satisfied (heap : MinHeap Nat) (k : Nat) (h_precond : get_frequent_values_precond heap k) :
    get_frequent_values_postcond heap k (get_frequent_values heap k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_2060_syn_1_iter_2060
