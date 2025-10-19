import Mathlib.Data.List.Basic
import Mathlib.Data.List.Sort

-- Precondition auxiliary definitions
structure ProcessedHeap where
  finalHeap : List Float
  insertedIndices : List Nat

def processHeap (heap : List Float) (float_list : List Float) (uint8_list : List UInt8) : ProcessedHeap :=
  let initial := { finalHeap := heap, insertedIndices := [] }
  List.foldl (λ (acc : ProcessedHeap) (i : Nat) =>
    match List.get? uint8_list i, List.get? float_list i with
    | some (0 : UInt8), _ => acc
    | some _, some f => 
      { finalHeap := List.insertionSort (fun a b => a ≤ b) (acc.finalHeap ++ [f]), 
        insertedIndices := acc.insertedIndices ++ [i] }
    | _, _ => acc)
    initial (List.range (min float_list.length uint8_list.length))

-- Precondition definitions
@[reducible, simp]
def get_k_smallest_indices_precond (heap : List Float) (float_list : List Float) (uint8_list : List UInt8) : Prop :=
  -- !benchmark @start precond
  uint8_list.length = float_list.length
  -- !benchmark @end precond

-- Code auxiliary definitions
def getSmallestIndicesAux (processed : ProcessedHeap) (float_list : List Float) : List Nat :=
  let heapSize := processed.finalHeap.length
  let indexedValues := processed.insertedIndices.map (λ idx => 
    (idx, float_list.get! idx))
  let sortedByValue := List.insertionSort (λ a b => 
    if a.2 < b.2 then true
    else if a.2 > b.2 then false
    else a.1 < b.1) indexedValues
  List.take heapSize sortedByValue |>.map Prod.fst

-- Main function definitions
def get_k_smallest_indices (heap : List Float) (float_list : List Float) (uint8_list : List UInt8) (h_precond : get_k_smallest_indices_precond heap float_list uint8_list) : List Nat :=
  -- !benchmark @start code
  let processed := processHeap heap float_list uint8_list
  let indexedValues := processed.insertedIndices.map (λ idx => (idx, float_list.get! idx))
  let sortedByValue := List.insertionSort (λ a b => 
    if a.2 < b.2 then true
    else if a.2 > b.2 then false
    else a.1 < b.1) indexedValues
  List.take processed.finalHeap.length sortedByValue |>.map Prod.fst
  -- !benchmark @end code

-- Postcondition auxiliary definitions
def getSmallestIndicesPost (processed : ProcessedHeap) (float_list : List Float) : List Nat :=
  let heapSize := processed.finalHeap.length
  let indexedValues := processed.insertedIndices.map (λ idx => 
    (idx, float_list.get! idx))
  let sortedByValue := List.insertionSort (λ a b => 
    if a.2 < b.2 then true
    else if a.2 > b.2 then false
    else a.1 < b.1) indexedValues
  List.take heapSize sortedByValue |>.map Prod.fst

-- Postcondition definitions
@[reducible, simp]
def get_k_smallest_indices_postcond (heap : List Float) (float_list : List Float) (uint8_list : List UInt8) (result: List Nat) (h_precond : get_k_smallest_indices_precond heap float_list uint8_list) : Prop :=
  -- !benchmark @start postcond
  let processed := processHeap heap float_list uint8_list
  result = getSmallestIndicesPost processed float_list ∧
  result.length = processed.finalHeap.length ∧
  ∀ i j, i < j → j < result.length → 
    let idx_i := result.get! i
    let idx_j := result.get! j
    let val_i := float_list.get! idx_i
    let val_j := float_list.get! idx_j
    val_i ≤ val_j ∧ (val_i = val_j → idx_i ≤ idx_j)
  -- !benchmark @end postcond

-- Proof content
theorem get_k_smallest_indices_postcond_satisfied (heap: List Float) (float_list: List Float) (uint8_list: List UInt8) (h_precond : get_k_smallest_indices_precond heap float_list uint8_list) :
    get_k_smallest_indices_postcond heap float_list uint8_list (get_k_smallest_indices heap float_list uint8_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof