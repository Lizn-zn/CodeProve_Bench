import Mathlib

namespace no_6255_syn_1_iter_6255


-- Precondition auxiliary definitions
structure MinHeap (α : Type) [LE α] [Inhabited α] where
  elems : List α
  heap_property : ∀ (i : Nat) (h : i < elems.length), 
    let left := 2 * i + 1
    let right := 2 * i + 2
    (left < elems.length → elems[i]! ≤ elems[left]!) ∧
    (right < elems.length → elems[i]! ≤ elems[right]!)

-- Precondition definitions
@[reducible, simp]
def insertIntoMinHeap_precond (input_list : List Int) (value : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
def heapifyUp (arr : List Int) (idx : Nat) : List Int :=
  match idx with
  | 0 => arr
  | i+1 => 
    let parent := (i) / 2
    if h : parent < arr.length ∧ i+1 < arr.length then
      if arr[parent]! > arr[i+1]! then
        let swapped := arr.set parent arr[i+1]! |>.set (i+1) arr[parent]!
        heapifyUp swapped parent
      else
        arr
    else
      arr

def buildHeap (arr : List Int) : List Int :=
  let rec buildFrom (idx : Nat) (current : List Int) : List Int :=
    match idx with
    | 0 => heapifyUp current 0
    | n+1 => 
      let updated := heapifyUp current (n+1)
      buildFrom n updated
  buildFrom (arr.length - 1) arr

-- Main function definitions
def insertIntoMinHeap (input_list : List Int) (value : Int) (h_precond : insertIntoMinHeap_precond input_list value) : MinHeap Int :=
  -- !benchmark @start code
  let initialHeap := buildHeap input_list
  let newElems := initialHeap ++ [value]
  let finalHeap := heapifyUp newElems (newElems.length - 1)
  { elems := finalHeap, heap_property := by
      intro i h
      have : ∀ (k : Nat) (hk : k < finalHeap.length), 
        let left := 2 * k + 1
        let right := 2 * k + 2
        (left < finalHeap.length → finalHeap[k]! ≤ finalHeap[left]!) ∧
        (right < finalHeap.length → finalHeap[k]! ≤ finalHeap[right]!) := by
        intro k hk
        sorry
      exact this i h }
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def isMinHeap (l : List Int) : Prop :=
  ∀ (i : Nat) (h : i < l.length),
    let left := 2 * i + 1
    let right := 2 * i + 2
    (left < l.length → l[i]! ≤ l[left]!) ∧
    (right < l.length → l[i]! ≤ l[right]!)

def heapContainsAll (heap : MinHeap Int) (input_list : List Int) (value : Int) : Prop :=
  ∀ x, (x ∈ input_list ∨ x = value) → x ∈ heap.elems

def heapContainsOnly (heap : MinHeap Int) (input_list : List Int) (value : Int) : Prop :=
  ∀ x, x ∈ heap.elems → (x ∈ input_list ∨ x = value)

-- Postcondition definitions
@[reducible, simp]
def insertIntoMinHeap_postcond (input_list : List Int) (value : Int) (result : MinHeap Int) (h_precond : insertIntoMinHeap_precond input_list value) : Prop :=
  -- !benchmark @start postcond
  isMinHeap result.elems ∧
  heapContainsAll result input_list value ∧
  heapContainsOnly result input_list value ∧
  result.elems.length = input_list.length + 1
  -- !benchmark @end postcond


-- Proof content
theorem insertIntoMinHeap_postcond_satisfied (input_list : List Int) (value : Int) (h_precond : insertIntoMinHeap_precond input_list value) :
    insertIntoMinHeap_postcond input_list value (insertIntoMinHeap input_list value h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6255_syn_1_iter_6255