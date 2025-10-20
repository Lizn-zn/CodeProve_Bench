import Mathlib

-- Precondition auxiliary definitions
inductive Heap : Type → Type 1 where
  | empty : Heap α
  | node : α → Heap α → Heap α → Heap α

def Heap.toList : Heap α → List α
  | .empty => []
  | .node x l r => x :: (toList l) ++ (toList r)

def Heap.isMinHeap : Heap Nat → Prop
  | .empty => True
  | .node x l r =>
      (∀ y ∈ l.toList, x ≤ y) ∧
      (∀ y ∈ r.toList, x ≤ y) ∧
      l.isMinHeap ∧
      r.isMinHeap

-- Precondition definitions
@[reducible, simp]
def heap_element_frequencies_precond (heap : Heap Nat) : Prop :=
  -- !benchmark @start precond
  heap.isMinHeap
  -- !benchmark @end precond


-- Code auxiliary definitions
def List.insertSorted (l : List (Nat × Nat)) (pair : Nat × Nat) : List (Nat × Nat) :=
  match l with
  | [] => [pair]
  | (x, fx) :: xs =>
    if pair.1 < x then
      pair :: (x, fx) :: xs
    else if pair.1 = x then
      (x, fx + pair.2) :: xs
    else
      (x, fx) :: xs.insertSorted pair

def Heap.foldM (heap : Heap α) (init : β) (f : β → α → β) : β :=
  match heap with
  | .empty => init
  | .node x l r =>
      let acc1 := f init x
      let acc2 := l.foldM acc1 f
      r.foldM acc2 f

def countElements (heap : Heap Nat) : List (Nat × Nat) :=
  heap.foldM [] (λ acc x => acc.insertSorted (x, 1))

-- Main function definitions
def heap_element_frequencies (heap : Heap Nat) (h_precond : heap_element_frequencies_precond (heap)) : List (Nat × Nat) :=
  -- !benchmark @start code
  countElements heap
  -- !benchmark @end code


-- Postcondition auxiliary definitions
def List.countElem (l : List Nat) (x : Nat) : Nat :=
  l.foldl (λ count y => if y = x then count + 1 else count) 0

def List.unique (l : List Nat) : List Nat :=
  l.foldl (λ acc x => if acc.contains x then acc else acc ++ [x]) []

def List.sorted (l : List Nat) : Prop :=
  match l with
  | [] => True
  | [_] => True
  | x :: y :: xs => x ≤ y ∧ (y :: xs).sorted

def List.sortedByKey (l : List (Nat × Nat)) : Prop :=
  match l with
  | [] => True
  | [_] => True
  | (x1, f1) :: (x2, f2) :: xs => x1 ≤ x2 ∧ ((x2, f2) :: xs).sortedByKey

-- Postcondition definitions
@[reducible, simp]
def heap_element_frequencies_postcond (heap : Heap Nat) (result: List (Nat × Nat)) (h_precond : heap_element_frequencies_precond (heap)) : Prop :=
  -- !benchmark @start postcond
  let elements := heap.toList
  let unique_elements := elements.unique
  let result_elements := result.map Prod.fst
  let result_frequencies := result.map Prod.snd

  -- All elements in result are from the heap
  result_elements ⊆ unique_elements ∧
  unique_elements ⊆ result_elements ∧

  -- Frequencies are correct
  (∀ (pair : Nat × Nat) (h : pair ∈ result),
    pair.snd = elements.countElem pair.fst) ∧

  -- Result is sorted by element value
  result.sortedByKey ∧

  -- All frequencies are positive
  (∀ (pair : Nat × Nat) (h : pair ∈ result), pair.snd > 0)
  -- !benchmark @end postcond


-- Proof content
theorem heap_element_frequencies_postcond_satisfied (heap: Heap Nat) (h_precond : heap_element_frequencies_precond (heap)) :
    heap_element_frequencies_postcond (heap) (heap_element_frequencies (heap) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
