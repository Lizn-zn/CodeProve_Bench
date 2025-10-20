import Mathlib

namespace no_6199_syn_1_iter_6199


-- Define MinHeap structure first
structure MinHeap (α : Type) where
  value : α
  left : Option (MinHeap α)
  right : Option (MinHeap α)

-- Precondition auxiliary definitions
-- No auxiliary definitions needed for precondition

-- Precondition definitions
@[reducible, simp]
def get_distinct_values_precond (heap : MinHeap UInt8) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- Define a recursive function to traverse the heap and collect distinct values
partial def MinHeap.collectDistinct (h : MinHeap UInt8) (acc : Set Int) : Set Int :=
  match h.left, h.right with
  | none, none => acc.insert (h.value.val : Int)
  | some l, none => MinHeap.collectDistinct l (acc.insert (h.value.val : Int))
  | none, some r => MinHeap.collectDistinct r (acc.insert (h.value.val : Int))
  | some l, some r => 
    let new_acc := acc.insert (h.value.val : Int)
    let acc_left := MinHeap.collectDistinct l new_acc
    MinHeap.collectDistinct r acc_left

-- Main function definitions
def get_distinct_values (heap : MinHeap UInt8) (h_precond : get_distinct_values_precond heap) : Set Int :=
  -- !benchmark @start code
  MinHeap.collectDistinct heap ∅
  -- !benchmark @end code


-- Postcondition auxiliary definitions
-- Define a helper function to extract all values from a MinHeap as a list
partial def MinHeap.toList (h : MinHeap UInt8) : List UInt8 :=
  h.value :: 
    (match h.left with
    | none => []
    | some l => MinHeap.toList l) ++
    (match h.right with
    | none => []
    | some r => MinHeap.toList r)

-- Postcondition definitions
@[reducible, simp]
def get_distinct_values_postcond (heap : MinHeap UInt8) (result: Set Int) (h_precond : get_distinct_values_precond heap) : Prop :=
  -- !benchmark @start postcond
  let values := MinHeap.toList heap
  let distinct_values : Set Int := (values.map (λ x => (x.val : Int))).toFinset
  result = distinct_values
  -- !benchmark @end postcond


-- Proof content
theorem get_distinct_values_postcond_satisfied (heap: MinHeap UInt8) (h_precond : get_distinct_values_precond heap) :
    get_distinct_values_postcond heap (get_distinct_values heap h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end no_6199_syn_1_iter_6199