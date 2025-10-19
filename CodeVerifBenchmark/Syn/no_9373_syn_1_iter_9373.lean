import Mathlib

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def build_min_heap_with_indices_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Heapify function to maintain min-heap property
partial def heapify (arr : Array Int) (i : Nat) : Array Int :=
  if h : i < arr.size then
    let left := 2 * i + 1
    let right := 2 * i + 2
    let smallest := i
    
    -- Find the smallest among node i and its children
    let smallest' := 
      if h_left : left < arr.size then
        if arr[left]! < arr[smallest]! then left else smallest
      else smallest
    let smallest'' := 
      if h_right : right < arr.size then
        if arr[right]! < arr[smallest']! then right else smallest'
      else smallest'
    
    -- If smallest is not the current node, swap and recursively heapify
    if h_smallest : smallest'' < arr.size then
      if smallest'' ≠ i then
        let arr := arr.swap i smallest''
        heapify arr smallest''
      else
        arr
    else
      arr
  else
    arr

-- Build min-heap from an array
def build_min_heap (arr : Array Int) : Array Int :=
  let start_idx := if arr.size > 0 then (arr.size / 2) - 1 else 0
  (List.range (start_idx + 1)).reverse.foldl (λ arr i => heapify arr i) arr

-- Main function definitions
def build_min_heap_with_indices (input_list : List Int) (h_precond : build_min_heap_with_indices_precond (input_list)) : Prod (Array Int) (List (Prod Int Nat)) :=
  -- !benchmark @start code
  let pairs := input_list.enum.map (λ (idx, val) => (val, idx))
  let heap_array := build_min_heap (Array.mk input_list)
  (heap_array, pairs)
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define the min-heap property for an array
def is_min_heap (arr : Array Int) : Prop :=
  ∀ (i : Nat), i < arr.size → 
    let left_child := 2 * i + 1
    let right_child := 2 * i + 2
    (left_child < arr.size → arr[i]! ≤ arr[left_child]!) ∧
    (right_child < arr.size → arr[i]! ≤ arr[right_child]!)

-- Define that the heap contains exactly the same elements as the input list
def heap_contains_same_elements (input_list : List Int) (heap : Array Int) : Prop :=
  Multiset.ofList input_list = Multiset.ofList heap.toList

-- Define that the index pairs preserve original order and indices
def preserves_original_indices (input_list : List Int) (pairs : List (Prod Int Nat)) : Prop :=
  pairs = input_list.enum.map (λ (idx, val) => (val, idx))

-- Postcondition definitions
@[reducible, simp]
def build_min_heap_with_indices_postcond (input_list : List Int) (result: Prod (Array Int) (List (Prod Int Nat))) (h_precond : build_min_heap_with_indices_precond (input_list)) : Prop :=
  -- !benchmark @start postcond
  let (heap, pairs) := result
  heap_contains_same_elements input_list heap ∧
  is_min_heap heap ∧
  preserves_original_indices input_list pairs
  -- !benchmark @end postcond


-- Proof content
theorem build_min_heap_with_indices_postcond_satisfied (input_list: List Int) (h_precond : build_min_heap_with_indices_precond (input_list)) :
    build_min_heap_with_indices_postcond (input_list) (build_min_heap_with_indices (input_list) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof