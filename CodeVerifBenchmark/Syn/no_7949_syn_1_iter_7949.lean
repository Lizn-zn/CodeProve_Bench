import Mathlib

-- Precondition auxiliary definitions
structure MinHeap (α : Type) [LE α] [Inhabited α] where
  data : Array α
  heap_property : ∀ i j, j < data.size → i < data.size → data[i]! ≤ data[j]! → True

-- Precondition definitions
@[reducible, simp]
def heap_to_finset_precond (heap : MinHeap Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- Code auxiliary definitions
-- No auxiliary definitions needed for this implementation

-- Main function definitions
def heap_to_finset (heap : MinHeap Nat) (h_precond : heap_to_finset_precond heap) : Finset Nat :=
  -- !benchmark @start code
  let elements := heap.data.toList
  elements.toFinset
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def MinHeap.toList (h : MinHeap Nat) : List Nat :=
  h.data.toList

-- Postcondition definitions
@[reducible, simp]
def heap_to_finset_postcond (heap : MinHeap Nat) (result: Finset Nat) (h_precond : heap_to_finset_precond heap) : Prop :=
  -- !benchmark @start postcond
  result = (MinHeap.toList heap).toFinset
  -- !benchmark @end postcond


-- Proof content
theorem heap_to_finset_postcond_satisfied (heap: MinHeap Nat) (h_precond : heap_to_finset_precond heap) :
    heap_to_finset_postcond heap (heap_to_finset heap h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof